# Lumy AI Coding Agent Instructions

## Project Overview
Lumy is a Flutter-based financial app for YNAB (You Need A Budget) users, built as a monorepo with:
- **Mobile app** (`apps/mobile/app/`): Flutter client supporting iOS, Android, and Web
- **Token server** (`apps/server/`): Dart Shelf server for OAuth token exchange
- **Supabase backend** (`apps/supabase/`): PostgreSQL database with Edge Functions for complex operations
- **Marketing site** (`marketing-site/`): Astro static site

## Architecture & Dependencies

### Monorepo Management
- **Melos** (`melos.yaml`) orchestrates the workspace. Use `melos` commands for cross-package operations:
  - `melos run codegen` - Run build_runner across all packages
  - `melos run format:flutter` / `melos run format:dart` - Format code
  - `melos run test:flutter:ci` / `melos run test:dart:ci` - Run tests with randomization

### Mobile App Stack
- **State Management**: flutter_bloc with Cubits (NOT traditional BLoC with events)
  - Cubits use `safeEmit()` extension (in `utils/_cubit.dart`) to prevent closed-state emissions
  - Factory pattern: each Cubit has `.create()` factory using `inject()` for dependencies
  - Stream subscriptions tracked in `CompositeSubscription` (`rxdart`), disposed in `close()`
- **Dependency Injection**: GetIt (`app/di.dart`) with manual wiring
  - Use `inject<T>()` helper to resolve dependencies
  - Named instances for HTTP clients: `inject(ynabHttpClient)`, `inject(discordHttpClient)`
  - Singletons registered in `setUpGraph()` with disposal callbacks
- **Data Serialization**: `dart_mappable` for JSON (NOT json_serializable)
  - Annotate with `@MappableClass()`, generates `.mapper.dart` files
  - Run `melos run codegen` after schema changes
- **Local Database**: Drift (SQLite) at `apps/mobile/app/lib/persistence/drift/`
  - Schema versions exported to `drift_schemas/` directory
  - Migration workflow detailed below
- **Navigation**: GoRouter with type-safe route definitions
- **HTTP**: Dio with custom `HttpClient` wrapper (`external/http_client.dart`)

### Backend Architecture
- **Supabase** provides auth (GoTrue), storage, and realtime subscriptions
- **Edge Functions** (Deno/TypeScript) in `apps/supabase/functions/` handle atomic operations:
  - insert/update/delete for spend trackers, category views, templates, frugal months
  - Call Postgres RPC functions (defined in `migrations/`) for transactional consistency
- **Token Server** (`apps/server/`) proxies YNAB OAuth to avoid exposing client secrets in mobile app

## Critical Developer Workflows

### Database Migrations
When modifying the Drift schema:
1. Update `schemaVersion` in database definition
2. `dart run build_runner build --delete-conflicting-outputs -v`
3. `dart run drift_dev schema dump lib/persistence/local/database.dart drift_schemas/`
4. `dart run drift_dev schema steps drift_schemas/ lib/persistence/schema_versions.dart`
5. Implement migration in `MigrationStrategy.onUpgrade` using `stepByStep`
6. `dart run drift_dev schema generate drift_schemas/ test/generated_migrations/`
7. Add version to test array in `database_test.dart` (e.g., `[1, 2, 3, ..., N]`)

**Critical**: Drift does NOT auto-migrate. You must write explicit migration steps.

### Running the App
Environment configs live in `.vscode/*.env` and are base64-encoded by `produce_env.sh`:
- **Local**: Uses local Supabase CLI stack (`supabase start`)
- **Dev/Prod**: Remote environments with separate Supabase projects

Launch configs in `.vscode/launch.json`:
- "Lumy (Local)" - Local development
- "Lumy (Dev)" - Dev environment
- "Lumy (Prod)" - Production

Each uses `--dart-define-from-file` to inject environment variables.

## Project-Specific Patterns

### Cubit Patterns
Every Cubit follows this structure:
```dart
class MyCubit extends Cubit<MyState> {
  MyCubit({required Dependency dep}) : _dep = dep, super(MyState.initial()) {
    fetch();
  }
  
  factory MyCubit.create() {
    return MyCubit(dep: inject());
  }
  
  final Dependency _dep;
  final _subs = CompositeSubscription();
  
  void fetch() {
    _subs.add(
      _dep.watchData().listen((data) {
        safeEmit(MyState(data: data));
      }),
    );
  }
  
  @override
  Future<void> close() async {
    await _subs.dispose();
    return super.close();
  }
}
```

### Repository Pattern
Repositories (`*_repository.dart`) own data streams and cache in `BehaviorSubject`:
- Expose `ValueStream<T> watch` for reactive data
- Use `factory .create()` with `inject()` for dependencies
- Subscribe to `AuthApi.onAuthenticated()` to refresh on login

### YNAB API Quirks (Documented in `apps/mobile/app/README.md`)
- **Pending transactions**: Only appear when matched, labeled with "P" in `import_id`
- **Null currency formats**: Older budgets may return null; user must update settings in YNAB
- **Name changes**: Payee/category renames do NOT propagate to transactions; refetch entities
- **Month-specific data**: `/months` endpoints don't auto-update if entity unchanged

### Testing
- Unit tests use fake implementations (`test/utilities/fake_*.dart`)
- `setUpTestGraph()` provides in-memory database and mocked services
- Drift schema tests verify each migration step using `verifier.startAt(version)`

## Key Files & Conventions
- `lib/app/di.dart` - Central DI setup; all services registered here
- `lib/main.dart` - App initialization, multi-provider setup, deep link handling
- `lib/utils/_cubit.dart` - `safeEmit()` extension to prevent closed-state errors
- `lib/persistence/settings.dart` - Reactive SharedPreferences wrapper with `watch*()` methods
- `apps/supabase/migrations/` - Postgres DDL and RPC function definitions
- `apps/supabase/functions/` - Deno Edge Functions calling `*_atomic` RPCs

### Feature Structure
Features follow clean architecture:
```
features/<name>/
  data/
    api/          # Backend API clients
    repositories/ # Data aggregation & caching
  domain/
    models/       # Business entities
    use_cases/    # Business logic (with .create() factories)
  presentation/
    flows/        # Multi-screen workflows with dedicated Cubits
    screens/      # Screen-level Cubits + UI
    widgets/      # Reusable components
```

## Don't Assume
- **NO code generation for JSON**: Use `dart_mappable`, not `json_serializable`
- **NO automatic database migrations**: Drift requires explicit `stepByStep` migrations
- **NO shared preferences synchronicity**: Use `Settings.watch*()` streams, not direct reads
- **NO lazy DI**: GetIt setup is explicit; add new services to `setUpGraph()` in `di.dart`
- **Environment variables**: Always via `--dart-define-from-file`; never hardcode secrets

## Integration Points
- **YNAB API**: OAuth via token server, rate-limited (200 req/hr), quirky response behaviors
- **Supabase Auth**: Email/magic-link login, JWT tokens for RLS policies
- **Firebase**: Analytics, Remote Config feature flags, Crashlytics via Sentry
- **Shorebird**: Code push for hot updates (Flutter over-the-air)
