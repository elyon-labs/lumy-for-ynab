/**
 * What this build points at.
 *
 * The values arrive through `app.config.ts`, which reads the environment at
 * build time and puts them in Expo's `extra`. Reading them back is one parse
 * in one place, rather than `process.env` references scattered through the
 * code: a missing value then fails on launch with the name of what is missing,
 * instead of as a request to `undefined/auth/v1`.
 *
 * The Supabase anon key is publishable by design — it is what the row-level
 * security policies are written against — so it ships in the bundle, as it
 * already does in the Flutter app. Nothing secret goes through here.
 */

export interface AppConfig {
  supabaseUrl: string;
  supabaseAnonKey: string;
  /** The scheme a magic link comes back to. No URL bar on a phone. */
  deepLinkScheme: string;
  supportEmail: string;
}

const REQUIRED = ['supabaseUrl', 'supabaseAnonKey', 'deepLinkScheme', 'supportEmail'] as const;

/**
 * Reads the config out of whatever `extra` holds, or says what is missing.
 *
 * Pure, so the failure is assertable without a build. It names every missing
 * key at once: finding them one launch at a time is the slowest way to
 * configure an app.
 */
export function parseConfig(extra: unknown): AppConfig {
  const candidate = (typeof extra === 'object' && extra !== null ? extra : {}) as Record<
    string,
    unknown
  >;

  const missing = REQUIRED.filter(
    (key) => typeof candidate[key] !== 'string' || candidate[key] === '',
  );

  if (missing.length > 0) {
    throw new Error(
      `Missing app config: ${missing.join(', ')}. Set the matching variables in .env — see .env.example.`,
    );
  }

  return {
    supabaseUrl: candidate.supabaseUrl as string,
    supabaseAnonKey: candidate.supabaseAnonKey as string,
    deepLinkScheme: candidate.deepLinkScheme as string,
    supportEmail: candidate.supportEmail as string,
  };
}
