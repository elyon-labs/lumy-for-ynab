import type {
  Account,
  Budget,
  CategoryGroup,
  DeltaPage,
  Month,
  Payee,
  ScheduledTransaction,
  Transaction,
  YnabClient,
} from '@lumy/ynab';

import type { DatabaseAdapter, Queryable } from '../adapters/types';
import { advanceKnowledge, readKnowledge } from './knowledge';
import {
  MONTH_DETAIL_RESOURCE,
  SYNC_ORDER,
  supportsDelta,
  type SyncResource,
} from './resources';
import {
  writeAccounts,
  writeBudgets,
  writeCategories,
  writeMonthDetail,
  writeMonths,
  writePayees,
  writeScheduledTransactions,
  writeTransactions,
} from './writers';

/**
 * The sync engine: the only thing in the app that writes YNAB data.
 *
 * It holds to the sequencing rules the Flutter app broke. For each resource:
 * fetch one page, then in one SQL transaction upsert the raw rows, reconcile
 * the child sets, re-derive the ledger for what was touched, and advance
 * server knowledge — last, and inside that same transaction. If any step
 * throws, the transaction rolls back and the next sync asks for the same
 * window again. There is no state in which the client believes it holds data
 * it never wrote.
 *
 * Fetches are serialised. YNAB allows 200 requests an hour against a token,
 * and a sync that fanned out would spend that allowance without knowing what
 * it had left.
 */

/**
 * How much of a full snapshot goes into one SQL transaction.
 *
 * A first sync of a long-lived budget can be tens of thousands of
 * transactions, and holding one transaction open across all of it would block
 * every read for the duration. Knowledge is written only in the final chunk,
 * so a failure part way through leaves committed rows that the next sync
 * simply writes again — which is harmless, because every write is an upsert
 * by id and the ledger is always delete-then-derive.
 */
export const DEFAULT_CHUNK_SIZE = 500;

export type SyncPhase = 'fetching' | 'writing' | 'done';

export interface SyncProgress {
  resource: SyncResource;
  phase: SyncPhase;
  /** Entities committed so far, of `total`. */
  written: number;
  /** How many the page carried. Null until it has been fetched. */
  total: number | null;
}

export interface ResourceSyncResult {
  resource: SyncResource;
  /** `full` whenever no knowledge was sent — a first sync, a repair, or `categories`. */
  mode: 'delta' | 'full';
  entities: number;
  knowledge: number;
}

export interface SyncReport {
  budgetId: string;
  startedAt: string;
  resources: readonly ResourceSyncResult[];
}

export interface SyncEngineOptions {
  db: DatabaseAdapter;
  client: YnabClient;
  chunkSize?: number;
  /** Injected by tests, so a recorded `synced_at` can be asserted. */
  now?: () => Date;
  onProgress?: (progress: SyncProgress) => void;
}

export interface SyncBudgetOptions {
  /**
   * Fetches every resource whole, ignoring stored knowledge.
   *
   * What repair runs. The knowledge rows are overwritten by the result rather
   * than cleared first, so a run that fails part way leaves the client no
   * worse off than before it started.
   */
  full?: boolean;
}

export interface SyncEngine {
  /**
   * Refreshes the budget list.
   *
   * Fetched whole every time: YNAB offers no delta for it, so there is no
   * knowledge to keep.
   */
  syncBudgetList(): Promise<readonly Budget[]>;
  syncBudget(budgetId: string, options?: SyncBudgetOptions): Promise<SyncReport>;
  /**
   * Fetches one month's detail, which is the only source of per-month category
   * figures.
   */
  syncMonthDetail(budgetId: string, month: string): Promise<void>;
}

export function createSyncEngine(options: SyncEngineOptions): SyncEngine {
  const { db, client } = options;
  const chunkSize = options.chunkSize ?? DEFAULT_CHUNK_SIZE;
  const now = options.now ?? (() => new Date());

  function chunk<T>(items: readonly T[]): readonly (readonly T[])[] {
    // An empty page still has to commit: it carries the knowledge that says
    // the client is up to date, and dropping that would re-fetch the same
    // window forever.
    if (items.length === 0) return [[]];

    const chunks: T[][] = [];
    for (let start = 0; start < items.length; start += chunkSize) {
      chunks.push(items.slice(start, start + chunkSize));
    }

    return chunks;
  }

  /**
   * Writes a page and advances its knowledge.
   *
   * The knowledge update is the last statement of the last chunk's
   * transaction. Everything the page said has committed by then, so the number
   * can never describe data that is not there.
   */
  async function commit<T>(
    key: { budgetId: string; resource: string; month?: string },
    page: DeltaPage<T>,
    write: (tx: Queryable, entities: readonly T[]) => Promise<void>,
    report: (written: number) => void,
  ): Promise<void> {
    const chunks = chunk(page.entities);
    const syncedAt = now().toISOString();
    let written = 0;

    for (const [index, entities] of chunks.entries()) {
      const isLast = index === chunks.length - 1;

      await db.transaction(async (tx) => {
        await write(tx, entities);
        if (isLast) {
          await advanceKnowledge(tx, key, { knowledge: page.serverKnowledge, syncedAt });
        }
      });

      written += entities.length;
      report(written);
    }
  }

  async function syncResource<T>(
    budgetId: string,
    resource: SyncResource,
    fetchPage: (lastKnowledgeOfServer: number | undefined) => Promise<DeltaPage<T>>,
    write: (tx: Queryable, entities: readonly T[]) => Promise<void>,
    full: boolean,
  ): Promise<ResourceSyncResult> {
    const stored = supportsDelta(resource)
      ? await readKnowledge(db, { budgetId, resource })
      : undefined;
    const lastKnowledgeOfServer = full ? undefined : stored?.knowledge;

    options.onProgress?.({ resource, phase: 'fetching', written: 0, total: null });
    const page = await fetchPage(lastKnowledgeOfServer);

    const total = page.entities.length;
    options.onProgress?.({ resource, phase: 'writing', written: 0, total });

    await commit(
      { budgetId, resource },
      page,
      write,
      (written) => options.onProgress?.({ resource, phase: 'writing', written, total }),
    );

    options.onProgress?.({ resource, phase: 'done', written: total, total });

    return {
      resource,
      mode: lastKnowledgeOfServer === undefined ? 'full' : 'delta',
      entities: total,
      knowledge: page.serverKnowledge,
    };
  }

  async function syncBudgetList(): Promise<readonly Budget[]> {
    const budgets = await client.getBudgets();

    await db.transaction((tx) => writeBudgets(tx, budgets));

    return budgets;
  }

  /**
   * Makes sure the budget row exists before anything references it.
   *
   * Every other table cascades from `budgets`, so a sync that started with the
   * accounts page would fail on the foreign key. Fetching the list is also
   * what a first sync needs anyway — it is where the currency format comes
   * from.
   */
  async function ensureBudget(budgetId: string): Promise<void> {
    const existing = await db.get('SELECT 1 FROM budgets WHERE id = ?', [budgetId]);
    if (existing !== undefined) return;

    await syncBudgetList();

    const synced = await db.get('SELECT 1 FROM budgets WHERE id = ?', [budgetId]);
    if (synced === undefined) {
      throw new Error(`YNAB does not list a budget ${budgetId} for this token.`);
    }
  }

  return {
    syncBudgetList,

    async syncBudget(budgetId, budgetOptions = {}) {
      const full = budgetOptions.full ?? false;
      const startedAt = now().toISOString();

      await ensureBudget(budgetId);

      const resources: ResourceSyncResult[] = [];

      for (const resource of SYNC_ORDER) {
        switch (resource) {
          case 'accounts':
            resources.push(
              await syncResource<Account>(
                budgetId,
                resource,
                (lastKnowledgeOfServer) =>
                  client.getAccounts({ budgetId, lastKnowledgeOfServer }),
                (tx, entities) => writeAccounts(tx, budgetId, entities),
                full,
              ),
            );
            break;

          case 'payees':
            resources.push(
              await syncResource<Payee>(
                budgetId,
                resource,
                (lastKnowledgeOfServer) => client.getPayees({ budgetId, lastKnowledgeOfServer }),
                (tx, entities) => writePayees(tx, budgetId, entities),
                full,
              ),
            );
            break;

          case 'categories':
            resources.push(
              await syncResource<CategoryGroup>(
                budgetId,
                resource,
                (lastKnowledgeOfServer) =>
                  client.getCategories({ budgetId, lastKnowledgeOfServer }),
                (tx, entities) => writeCategories(tx, budgetId, entities),
                full,
              ),
            );
            break;

          case 'months':
            resources.push(
              await syncResource<Month>(
                budgetId,
                resource,
                (lastKnowledgeOfServer) => client.getMonths({ budgetId, lastKnowledgeOfServer }),
                (tx, entities) => writeMonths(tx, budgetId, entities),
                full,
              ),
            );
            break;

          case 'transactions':
            resources.push(
              await syncResource<Transaction>(
                budgetId,
                resource,
                (lastKnowledgeOfServer) =>
                  client.getTransactions({ budgetId, lastKnowledgeOfServer }),
                (tx, entities) => writeTransactions(tx, budgetId, entities),
                full,
              ),
            );
            break;

          case 'scheduled_transactions':
            resources.push(
              await syncResource<ScheduledTransaction>(
                budgetId,
                resource,
                (lastKnowledgeOfServer) =>
                  client.getScheduledTransactions({ budgetId, lastKnowledgeOfServer }),
                (tx, entities) => writeScheduledTransactions(tx, budgetId, entities),
                full,
              ),
            );
            break;
        }
      }

      return { budgetId, startedAt, resources };
    },

    async syncMonthDetail(budgetId, month) {
      const detail = await client.getMonth(budgetId, month);
      const syncedAt = now().toISOString();

      await db.transaction(async (tx) => {
        await writeMonthDetail(tx, budgetId, detail);
        // The month endpoint carries no server knowledge, so what is recorded
        // here is when it was last read rather than how far it has got.
        await advanceKnowledge(
          tx,
          { budgetId, resource: MONTH_DETAIL_RESOURCE, month },
          { knowledge: 0, syncedAt },
        );
      });
    },
  };
}
