# Setup

## Prerequisites

- Flutter via `mise` using `flutter@3.41.4`.
- Dart SDK from the Flutter toolchain.
- Node.js and pnpm for the React Native app, the marketing site, and Supabase tooling. `mise.toml` pins the versions.
- Ruby, pinned in `mise.toml`, so that CocoaPods is on PATH for the React Native app's iOS builds.
- Xcode for iOS builds and Android Studio for Android builds.
- Supabase CLI for the local stack.
- A YNAB OAuth application for local development.

## Mobile App

```sh
cd apps/mobile/app
mise exec flutter@3.41.4 -- flutter pub get
mise exec flutter@3.41.4 -- dart run build_runner build --delete-conflicting-outputs
```

Feature flags are toggled locally from the in-app debug menu (Settings → Debug → Feature flags), so no external configuration is required to build or run.

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

It serves the API on `http://localhost:54321`, which is what both apps' local
config points at, and the emailed sign-in links land in Inbucket on
`http://localhost:54324` rather than a real inbox.

## Token Server

```sh
cd apps/server
dart pub get
dart run bin/server.dart
```

Configure the server with local environment variables for your YNAB OAuth client ID, client secret, redirect URI, and any host/port settings used by the server.

It serves on `http://localhost:8080` by default, which is what both apps' local
config points at. It holds the client secret, which is why neither app has one:
they post a code or a refresh token to this server and it does the exchange.

## React Native App

The Expo app and the marketing site share one pnpm workspace rooted at the
repository root, so dependencies are installed there once.

```sh
pnpm install
```

### Configuration

What the app points at comes from `apps/mobile-rn/.env`, which `app.config.ts`
reads into Expo's `extra` and `src/config` parses back. Copy the example and
fill it in:

```sh
cp apps/mobile-rn/.env.example apps/mobile-rn/.env
```

A missing or empty value fails on launch naming itself. The values are read
when Metro starts, so changing `.env` needs Metro restarted rather than the
native project rebuilt.

The defaults in `.env.example` point at the local Supabase stack and the local
token server, so **start both before the app** or every request fails with
"Could not connect to the server". `localhost` resolves from the iOS simulator,
which shares the host's network; a physical device needs the Mac's LAN address
instead. Point the two URLs at the deployed services to run against production
data.

The same values are in the Flutter app's env file under slightly different
names — `CLIENT_ID` there is `YNAB_CLIENT_ID` here, and the rest match.

### Running

```sh
pnpm mobile:start
```

Run on a device or simulator with `pnpm mobile:ios` or `pnpm mobile:android`.
Both prebuild the native projects, which are generated rather than committed.

Checks:

```sh
pnpm typecheck
pnpm lint
pnpm test
```

## Marketing Site

```sh
pnpm install
pnpm web:dev
```

Build with:

```sh
pnpm web:build
```

## Public Configuration

Do not commit production service files, signing files, store credentials, or deployment-only configuration. Use your own local project values and keep secrets outside git.
