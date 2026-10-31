import Constants from 'expo-constants';

import { parseConfig, type AppConfig } from './config';

/**
 * This build's config, parsed once.
 *
 * `expo-constants` is reached only here, so the parse above stays pure and the
 * failure for a missing value is a test rather than a launch.
 */
let parsed: AppConfig | null = null;

export function appConfig(): AppConfig {
  parsed ??= parseConfig(Constants.expoConfig?.extra);

  return parsed;
}

export * from './config';
