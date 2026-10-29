import { describe, expect, it } from 'vitest';

import { schemaVersion } from '../migrate';
import { MIGRATIONS, type Migration } from '../migrations';
import { createHarness } from './harness';

const widgets: Migration = {
  id: 1,
  name: 'widgets',
  statements: ['CREATE TABLE widgets (id INTEGER PRIMARY KEY)'],
};

describe('createHarness', () => {
  it('opens a database at the current schema', async () => {
    const harness = await createHarness();

    expect(await schemaVersion(harness.db)).toBe(MIGRATIONS.length);

    await harness.close();
  });

  it('can run against a supplied schema instead', async () => {
    const harness = await createHarness({ migrations: [widgets] });

    await harness.db.run('INSERT INTO widgets (id) VALUES (?)', [1]);

    expect(await harness.db.all('SELECT * FROM widgets')).toEqual([{ id: 1 }]);

    await harness.close();
  });

  it('records the changes a test provokes', async () => {
    const harness = await createHarness({ migrations: [widgets] });

    await harness.db.transaction(async (tx) => {
      await tx.run('INSERT INTO widgets (id) VALUES (?)', [1]);
    });

    expect(harness.changes).toEqual([['widgets']]);

    await harness.close();
  });

  it('gives each test its own database', async () => {
    const a = await createHarness({ migrations: [widgets] });
    const b = await createHarness({ migrations: [widgets] });

    await a.db.run('INSERT INTO widgets (id) VALUES (?)', [1]);

    // In memory and per-harness, so tests neither share state nor need
    // teardown between cases.
    expect(await b.db.all('SELECT * FROM widgets')).toEqual([]);

    await a.close();
    await b.close();
  });
});
