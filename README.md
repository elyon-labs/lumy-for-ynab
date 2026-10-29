# Lumy

<p align="center">
  <img src="docs/assets/lumy-icon.png" alt="Lumy app icon">
</p>

Lumy is a free and open-source Flutter app for YNAB users. This repository includes the mobile app, a Supabase local/backend project, and a Dart OAuth token server.

## Donations

<p align="center">
  <a href="https://buymeacoffee.com/btrautmann">
    <img src="docs/assets/buy-me-a-coffee.png" alt="Buy Me A Coffee">
  </a>
</p>

<p align="center">
  If you would like to support Lumy, you can make a donation <a href="https://www.buymeacoffee.com/btrautmann">here</a>.
</p>


## Project Structure

```text
lumy/
├── apps/
│   ├── mobile/app/        # Flutter application
│   ├── mobile-rn/         # Expo React Native application
│   ├── server/            # Dart token server for YNAB OAuth
│   └── supabase/          # Supabase config, functions, and migrations
└── marketing-site/        # Astro marketing site
```

The Flutter app is the one that ships today. The React Native app is being built
to replace it; see `apps/mobile-rn`.

## Development

Start with [docs/setup.md](docs/setup.md). It covers the mobile app, Supabase local stack, token server, and marketing site.

Flutter and Dart checks:

```sh
mise exec flutter@3.41.4 -- dart format .
mise exec flutter@3.41.4 -- flutter analyze
mise exec flutter@3.41.4 -- flutter test
```

JavaScript checks, from the repository root:

```sh
pnpm install
pnpm typecheck
pnpm lint
pnpm test
```

## Services

| Service | Purpose |
| --- | --- |
| Mobile App | Flutter client for iOS, Android, and Web |
| Mobile App (RN) | Expo client for iOS and Android |
| Supabase | Auth, PostgreSQL, storage, realtime, and Edge Functions |
| Token Server | YNAB OAuth token exchange |
| Marketing Site | Astro static website |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

See [SECURITY.md](SECURITY.md).

## License

Lumy is available under the [MIT License](LICENSE).
