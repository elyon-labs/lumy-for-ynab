import type { ExpoConfig } from 'expo/config';

const BUNDLE_IDENTIFIER = 'com.brandontrautmann.lumy';

/**
 * What this build points at, read from the environment and handed to the app
 * through `extra`. `src/config` parses it back and is the only reader.
 *
 * The Supabase anon key is publishable by design — the row-level security
 * policies are written against it — so it ships in the bundle, as it already
 * does in the Flutter app. Nothing secret belongs here.
 *
 * Values come from `.env` locally and from EAS environment variables in a
 * build; `.env.example` lists them. A missing one fails on launch naming
 * itself rather than as a request to `undefined`.
 */
const extra = {
  supabaseUrl: process.env.SUPABASE_URL ?? '',
  supabaseAnonKey: process.env.SUPABASE_ANON_KEY ?? '',
  deepLinkScheme: BUNDLE_IDENTIFIER,
  supportEmail: process.env.SUPPORT_EMAIL ?? '',
};

const config: ExpoConfig = {
  name: 'Lumy',
  slug: 'lumy',
  owner: 'elyon-labs',
  version: '0.0.1',
  orientation: 'portrait',
  // The scheme the shipped Flutter app already registers on both platforms.
  // YNAB redirects the OAuth callback here, so it has to stay the same for the
  // RN build to be an update rather than a new app.
  scheme: BUNDLE_IDENTIFIER,
  userInterfaceStyle: 'automatic',
  icon: './assets/icon.png',
  ios: {
    bundleIdentifier: BUNDLE_IDENTIFIER,
    supportsTablet: true,
    infoPlist: {
      ITSAppUsesNonExemptEncryption: false,
    },
  },
  android: {
    package: BUNDLE_IDENTIFIER,
  },
  plugins: [
    'expo-router',
    'expo-secure-store',
    'expo-localization',
    [
      'expo-splash-screen',
      {
        image: './assets/splash-icon.png',
        imageWidth: 160,
        // Matches the Flutter app's splash, which is black in both schemes.
        backgroundColor: '#000000',
        dark: {
          backgroundColor: '#000000',
        },
      },
    ],
  ],
  experiments: {
    typedRoutes: true,
  },
  extra,
};

export default config;
