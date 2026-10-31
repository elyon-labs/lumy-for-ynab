/**
 * What the person chose.
 *
 * The registry and the period model are plain data and pure functions; the
 * writer is here and the reader is in `src/read`, where every read in this
 * package is. Nothing in this folder knows about React: the providers that
 * put a setting on screen are `apps/mobile-rn/src/settings/`, and the
 * background sync task reads the selected budget and period with no provider
 * at all.
 */
export * from './definitions';
export * from './period';
export * from './store';
