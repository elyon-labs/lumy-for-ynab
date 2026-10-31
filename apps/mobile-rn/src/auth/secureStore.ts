import * as SecureStore from 'expo-secure-store';

import type { KeyValueStore } from './sessionStore';

/**
 * The device's own credential store: the Keychain on iOS, the Keystore on
 * Android.
 *
 * The one module that names `expo-secure-store`, so everything above it works
 * against `KeyValueStore` and is testable without a device.
 *
 * `WHEN_UNLOCKED` rather than the default, so the session cannot be read while
 * the phone is locked. The background sync task in PR 32 runs while the device
 * is unattended but not while it is locked, which is the behaviour this picks:
 * a sync that waits for an unlock is better than a session readable without
 * one. It is deliberately not `..._THIS_DEVICE_ONLY`, so the session restores
 * with a backup, which is what keeps signing in a one-time act.
 */
const OPTIONS: SecureStore.SecureStoreOptions = {
  keychainAccessible: SecureStore.WHEN_UNLOCKED,
};

export const secureStore: KeyValueStore = {
  getItem: (key) => SecureStore.getItemAsync(key, OPTIONS),
  setItem: (key, value) => SecureStore.setItemAsync(key, value, OPTIONS),
  removeItem: (key) => SecureStore.deleteItemAsync(key, OPTIONS),
};
