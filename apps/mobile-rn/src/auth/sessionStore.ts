/**
 * Where the Supabase session lives.
 *
 * It is a credential, so it goes in the Keychain on iOS and the Keystore on
 * Android rather than in AsyncStorage, which is a plain file any backup picks
 * up. That is what `expo-secure-store` wraps.
 *
 * The complication is size. A session is JSON carrying an access-token JWT, a
 * refresh token, and the user — commonly two to three kilobytes — and
 * `SecureStore` documents 2048 bytes as the point past which a value may not
 * be stored at all. So a value is split across numbered keys and reassembled
 * on read. Without that, signing in works until the JWT grows a claim.
 */

/**
 * The store the session is kept in.
 *
 * An interface rather than a direct import of `expo-secure-store`, so the
 * chunking below is testable against a plain map: what it has to get right is
 * arithmetic and bookkeeping, neither of which needs a Keychain.
 */
export interface KeyValueStore {
  getItem: (key: string) => Promise<string | null>;
  setItem: (key: string, value: string) => Promise<void>;
  removeItem: (key: string) => Promise<void>;
}

/**
 * How much of a value goes in one key.
 *
 * Under `SecureStore`'s documented 2048-byte limit with room to spare, and
 * measured in UTF-16 code units where the limit is in bytes — a non-ASCII
 * character can be several bytes, and an email address or a display name in
 * the user object can carry one.
 */
export const CHUNK_SIZE = 1024;

/** The key holding how many chunks the value was split into. */
function countKey(key: string): string {
  return `${key}.chunks`;
}

function chunkKey(key: string, index: number): string {
  return `${key}.${index}`;
}

function chunksIn(value: string): string[] {
  const chunks: string[] = [];
  for (let at = 0; at < value.length; at += CHUNK_SIZE) {
    chunks.push(value.slice(at, at + CHUNK_SIZE));
  }

  return chunks;
}

/**
 * Splits a value across as many keys as it needs.
 *
 * The count is written last, so a write interrupted part way leaves a count
 * that still describes a complete value — the previous one — rather than a
 * count pointing at chunks that were never written.
 *
 * Chunks left over from a longer previous value are removed. Missing that is
 * how a store like this breaks: a short session written over a long one would
 * leave the tail behind, and the next read would reassemble a prefix of the
 * new value with the end of the old one glued to it.
 */
export async function setChunked(
  store: KeyValueStore,
  key: string,
  value: string,
): Promise<void> {
  const previous = await chunkCount(store, key);
  const chunks = chunksIn(value);

  for (const [index, chunk] of chunks.entries()) {
    await store.setItem(chunkKey(key, index), chunk);
  }

  for (let index = chunks.length; index < previous; index += 1) {
    await store.removeItem(chunkKey(key, index));
  }

  await store.setItem(countKey(key), String(chunks.length));
}

async function chunkCount(store: KeyValueStore, key: string): Promise<number> {
  const raw = await store.getItem(countKey(key));
  if (raw === null) return 0;

  const count = Number(raw);

  return Number.isInteger(count) && count >= 0 ? count : 0;
}

/**
 * Reassembles a value, or reports nothing.
 *
 * A chunk the count promised but the store does not have means the value is
 * incomplete, and half a session is worse than none: it would fail to parse on
 * every launch and never be replaced. So it reads as absent, and the next sign
 * in writes a whole one.
 */
export async function getChunked(store: KeyValueStore, key: string): Promise<string | null> {
  const count = await chunkCount(store, key);
  if (count === 0) return null;

  const chunks: string[] = [];
  for (let index = 0; index < count; index += 1) {
    const chunk = await store.getItem(chunkKey(key, index));
    if (chunk === null) return null;

    chunks.push(chunk);
  }

  return chunks.join('');
}

/** Removes every chunk and the count, so nothing is left to reassemble. */
export async function removeChunked(store: KeyValueStore, key: string): Promise<void> {
  const count = await chunkCount(store, key);

  for (let index = 0; index < count; index += 1) {
    await store.removeItem(chunkKey(key, index));
  }

  await store.removeItem(countKey(key));
}

/**
 * The storage adapter `supabase-js` is given.
 *
 * It asks for `getItem` / `setItem` / `removeItem` and does not care that each
 * one is several Keychain entries.
 */
export function createChunkedStorage(store: KeyValueStore): KeyValueStore {
  return {
    getItem: (key) => getChunked(store, key),
    setItem: (key, value) => setChunked(store, key, value),
    removeItem: (key) => removeChunked(store, key),
  };
}
