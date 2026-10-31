import { beforeEach, describe, expect, it } from 'vitest';

import {
  CHUNK_SIZE,
  createChunkedStorage,
  getChunked,
  removeChunked,
  setChunked,
  type KeyValueStore,
} from './sessionStore';

/**
 * The session is too big for one Keychain entry, so it is split across
 * several. What that has to get right is arithmetic and bookkeeping, and
 * neither needs a device — this runs against a map.
 */

const KEY = 'sb-lumy-auth-token';

interface RecordingStore extends KeyValueStore {
  items: Map<string, string>;
  /** Every call, in order, for the assertions about ordering. */
  calls: string[];
}

function createStore(): RecordingStore {
  const items = new Map<string, string>();
  const calls: string[] = [];

  return {
    items,
    calls,
    getItem: async (key) => {
      calls.push(`get ${key}`);

      return items.get(key) ?? null;
    },
    setItem: async (key, value) => {
      calls.push(`set ${key}`);
      items.set(key, value);
    },
    removeItem: async (key) => {
      calls.push(`remove ${key}`);
      items.delete(key);
    },
  };
}

/** A session-shaped value of a given length. */
function aValueOf(length: number): string {
  return 'x'.repeat(length);
}

describe('a value that fits in one entry', () => {
  let store: RecordingStore;

  beforeEach(() => {
    store = createStore();
  });

  it('is still written as a chunk, so reading is one path', async () => {
    await setChunked(store, KEY, 'short');

    expect(store.items.get(`${KEY}.0`)).toBe('short');
    expect(store.items.get(`${KEY}.chunks`)).toBe('1');
    expect(await getChunked(store, KEY)).toBe('short');
  });

  it('reads as absent when nothing was written', async () => {
    expect(await getChunked(store, KEY)).toBeNull();
  });
});

describe('a session too big for one entry', () => {
  let store: RecordingStore;
  const session = aValueOf(CHUNK_SIZE * 2 + 200);

  beforeEach(() => {
    store = createStore();
  });

  it('comes back exactly as it went in', async () => {
    await setChunked(store, KEY, session);

    expect(await getChunked(store, KEY)).toBe(session);
  });

  it('puts no more than the limit in any one entry', async () => {
    // The whole reason this module exists: `SecureStore` documents 2048 bytes
    // as the point past which a value may not be stored at all, and a session
    // carrying a JWT goes past it.
    await setChunked(store, KEY, session);

    for (const [key, value] of store.items) {
      if (key.endsWith('.chunks')) continue;

      expect(value.length, key).toBeLessThanOrEqual(CHUNK_SIZE);
    }
  });

  it('writes the count after the chunks it counts', async () => {
    // A write interrupted part way then leaves a count describing a complete
    // value — the previous one — rather than one pointing at chunks that were
    // never written.
    await setChunked(store, KEY, session);

    const countAt = store.calls.indexOf(`set ${KEY}.chunks`);
    const lastChunkAt = store.calls.lastIndexOf(`set ${KEY}.2`);

    expect(countAt).toBeGreaterThan(lastChunkAt);
  });
});

describe('overwriting', () => {
  let store: RecordingStore;

  beforeEach(() => {
    store = createStore();
  });

  it('leaves no tail behind when the new value is shorter', async () => {
    // This is the bug this module is most likely to have. A short session
    // written over a long one would otherwise leave the old tail in place,
    // and the next read would glue the end of the old value onto the new one.
    const long = aValueOf(CHUNK_SIZE * 3);
    const short = aValueOf(CHUNK_SIZE);

    await setChunked(store, KEY, long);
    await setChunked(store, KEY, short);

    expect(await getChunked(store, KEY)).toBe(short);
    expect(store.items.has(`${KEY}.1`)).toBe(false);
    expect(store.items.has(`${KEY}.2`)).toBe(false);
  });

  it('grows without leaving a stale count', async () => {
    await setChunked(store, KEY, aValueOf(10));
    await setChunked(store, KEY, aValueOf(CHUNK_SIZE * 2));

    expect(store.items.get(`${KEY}.chunks`)).toBe('2');
    expect(await getChunked(store, KEY)).toHaveLength(CHUNK_SIZE * 2);
  });
});

describe('a store that has lost an entry', () => {
  it('reads as absent rather than as a truncated session', async () => {
    // Half a session is worse than none: it would fail to parse on every
    // launch and never be replaced. Absent means the next sign in writes a
    // whole one.
    const store = createStore();
    await setChunked(store, KEY, aValueOf(CHUNK_SIZE * 2));

    store.items.delete(`${KEY}.1`);

    expect(await getChunked(store, KEY)).toBeNull();
  });

  it('reads as absent when the count is not a number', async () => {
    const store = createStore();
    store.items.set(`${KEY}.chunks`, 'two');
    store.items.set(`${KEY}.0`, 'something');

    expect(await getChunked(store, KEY)).toBeNull();
  });
});

describe('removing a session', () => {
  it('leaves nothing to reassemble', async () => {
    const store = createStore();
    await setChunked(store, KEY, aValueOf(CHUNK_SIZE * 2 + 1));

    await removeChunked(store, KEY);

    expect(store.items.size).toBe(0);
    expect(await getChunked(store, KEY)).toBeNull();
  });
});

describe('the adapter supabase-js is given', () => {
  it('is a plain key-value store over several entries', async () => {
    const store = createStore();
    const storage = createChunkedStorage(store);
    const session = aValueOf(CHUNK_SIZE + 5);

    await storage.setItem(KEY, session);
    expect(await storage.getItem(KEY)).toBe(session);

    await storage.removeItem(KEY);
    expect(await storage.getItem(KEY)).toBeNull();
  });
});
