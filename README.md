# Lumy

Lumy is a free and open-source Flutter app for YNAB users. This repository includes the mobile app, a Supabase local/backend project, and a Dart OAuth token server.

## Donations

[![Buy Me A Coffee](https://shields.io)](https://buymeacoffee.com/btrautmann)

If you would like to support Lumy, you can make a donation [here](https://www.buymeacoffee.com/btrautmann).


## Project Structure

```text
lumy/
├── apps/
│   ├── mobile/app/        # Flutter application
│   ├── server/            # Dart token server for YNAB OAuth
│   └── supabase/          # Supabase config, functions, and migrations
└── marketing-site/        # Astro marketing site
```

## Development

Start with [docs/setup.md](docs/setup.md). It covers the mobile app, Supabase local stack, token server, and marketing site.

Common checks:

```sh
mise exec flutter@3.41.4 -- dart format .
mise exec flutter@3.41.4 -- flutter analyze
mise exec flutter@3.41.4 -- flutter test
```

## Services

| Service | Purpose |
| --- | --- |
| Mobile App | Flutter client for iOS, Android, and Web |
| Supabase | Auth, PostgreSQL, storage, realtime, and Edge Functions |
| Token Server | YNAB OAuth token exchange |
| Marketing Site | Astro static website |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

See [SECURITY.md](SECURITY.md).

## License

Lumy is available under the [MIT License](LICENSE).
