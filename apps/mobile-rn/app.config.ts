import type { ExpoConfig } from 'expo/config';

const BUNDLE_IDENTIFIER = 'com.brandontrautmann.lumy';

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
};

export default config;
