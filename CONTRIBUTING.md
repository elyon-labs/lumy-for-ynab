# Contributing

Thanks for helping improve Lumy.

## Setup

Follow [docs/setup.md](docs/setup.md) before opening a change.

## Checks

Run the relevant checks before submitting a pull request:

```sh
mise exec flutter@3.41.4 -- dart format .
mise exec flutter@3.41.4 -- flutter analyze
mise exec flutter@3.41.4 -- flutter test
```

For generated Dart files, run:

```sh
cd apps/mobile/app
mise exec flutter@3.41.4 -- dart run build_runner build --delete-conflicting-outputs
```

## Pull Requests

- Keep changes focused.
- Add or update tests for behavior changes.
- Do not commit production credentials, signing files, app-store release files, or deployment-only configuration.
- Use public-safe local configuration templates instead of private project values.
