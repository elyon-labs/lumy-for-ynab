# Setup

## Prerequisites

- Flutter via `mise` using `flutter@3.41.4`.
- Dart SDK from the Flutter toolchain.
- Node.js for the marketing site and Supabase tooling.
- Supabase CLI for the local stack.
- A YNAB OAuth application for local development.

## Mobile App

```sh
cd apps/mobile/app
mise exec flutter@3.41.4 -- flutter pub get
mise exec flutter@3.41.4 -- dart run build_runner build --delete-conflicting-outputs
```

Feature flags are toggled locally from the in-app debug menu (Settings → Debug →
Feature flags), so no external configuration is required to build or run.

Create a local environment file with your own development values. The app expects the `ENVIRONMENT` dart define to contain a base64-encoded dotenv payload.

Required values:

```dotenv
ENVIRONMENT_NAME=local
LOG_LEVEL=debug
YNAB_AUTHORIZE_URL=
YNAB_TOKEN_URL=
MOBILE_DEEPLINK_URI=
WEB_DEEPLINK_URI=
CLIENT_ID=
YNAB_BASE_URL=https://api.ynab.com/v1
FEEDBACK_BOARD_URL=
FEEDBACK_WEBHOOK=
COMMUNITY_SERVER_URL=
ANDROID_STORE_URL=
IOS_STORE_URL=
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPPORT_EMAIL=
```

Run with:

```sh
mise exec flutter@3.41.4 -- flutter run --dart-define=ENVIRONMENT="$(base64 -i .env.local)"
```

## Supabase Local Stack

```sh
cd apps/supabase
supabase start
supabase db reset
```

The local stack runs migrations and functions from `apps/supabase`. Configure local secrets with `supabase secrets set` when a function needs one.

## Token Server

```sh
cd apps/server
dart pub get
dart run bin/server.dart
```

Configure the server with local environment variables for your YNAB OAuth client ID, client secret, redirect URI, and any host/port settings used by the server.

## Marketing Site

```sh
cd marketing-site
npm install
npm run dev
```

Build with:

```sh
npm run build
```

## Public Configuration

Do not commit production service files, signing files, store credentials, or deployment-only configuration. Use your own local project values and keep secrets outside git.
