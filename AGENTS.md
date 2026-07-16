# AGENTS.md — BuscoBien

Flutter app (real estate promotion platform, Mexico). Riverpod 3.x + Freezed + Dio + Google Maps.
CouchDB via a separate Node.js API repo — Flutter never connects to CouchDB directly.

## Build & run

```powershell
# All commands need --dart-define-from-file=defines.json for credentials
flutter run -d chrome --wasm --dart-define-from-file=defines.json   # Web dev
flutter run -d windows              --dart-define-from-file=defines.json   # Windows
flutter run                        --dart-define-from-file=defines.json   # Android/iOS
flutter build web --wasm            --dart-define-from-file=defines.json   # Web prod
flutter analyze                                                             # Lint
```

- **Always** `--wasm` for web. Web build without it is wrong.
- `defines.json` (in `.gitignore`) has CouchDB creds + Google Maps keys. Access via `String.fromEnvironment()` in `lib/14_geolocalizacion/app_keys.dart` and `lib/40_security/direccionip.dart`.
- `.env` is legacy. Do not use it for secrets.

## Architecture

```
Flutter App → Node.js API (separate repo) → CouchDB (https://citigov.cloud:6984)
```

- Flutter **never** has CouchDB credentials. All DB access goes through the API.
- Backend is in a separate repo (Node.js + Express, `nano` for CouchDB, JWT auth). This repo is Flutter-only.
- Mailer microservice at `server/buscobien-mailer/` (Node.js, runs on server via pm2 + Apache reverse proxy).

## State management & data layer

- **Riverpod 3.x** with `riverpod_generator` — run `build_runner` after adding/editing providers with annotations.
- **Freezed** + `json_serializable` for models. Generated files: `.freezed.dart`, `.g.dart`.
- **Dio** for HTTP with JWT interceptor (auto-attaches token from secure storage).
- JWT storage: `flutter_secure_storage` on iOS/Android, `shared_preferences` on Web/Windows.

### Code generation

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Run after editing Freezed models or Riverpod provider annotations.

## Navigation

- Custom `AppRoutes.routeGenerate()` as `onGenerateRoute` in MaterialApp (`lib/07_routes/app_routes.dart`).
- Route params via `routes_parameters.dart`. **No GoRouter**, no Navigator 2.0.
- `setPathUrlStrategy()` active in `main.dart` — clean URLs on Web.

## Critical code rules

1. **`if (!mounted) return;`** — required after **every `await`** in StatefulWidget code that updates UI.
2. **No hardcoded colors** — always use the global `appTheme` ColorScheme from `lib/20_var_globales/var_color_themes.dart`. Read `_documentacion/antigravity_ui_rules.md` before any UI work.
3. M3 widgets: `NavigationBar` (not `BottomNavigationBar`), `FilledButton` (not `RaisedButton`).
4. Icon codepoints must be in range `0xe000`–`0xe900` — avoid `_outlined` variants in `0xee00+`.
5. Views are dumb — no business logic in widgets. Use Riverpod notifiers.

## SSH (server 190.92.151.34:7822)

- **PowerShell only** — Bash cannot access Windows ssh-agent. The key has a passphrase.
- Aliases: `miservidor` (user `deploy`), `miservidor-root` (user `root`).
- Each session: `Start-Service ssh-agent; ssh-add $env:USERPROFILE\.ssh\id_ed25519`
- Verify: `ssh miservidor "echo ok"`
- Config in `~/.ssh/config` (both aliases, port 7822, key `~/.ssh/id_ed25519`).

## CouchDB conventions

- DB names: `buscobien_*` (e.g. `buscobien_invitaciones`, `buscobien_grupos`, `buscobien_mensajes`).
- Doc IDs: semantic prefix + UUID (`user:uuid`, `propiedad:uuid`, `mensaje:uuid`, `grupo:uuid`).
- Prefer Mango queries over MapReduce.

## Tests

- One smoke test exists at `test/widget_test.dart`. Run with `flutter test`.
- No integration test infrastructure.

## Reference docs (in-repo)

- `_documentacion/antigravity_ui_rules.md` — M3 UI rules. Mandatory read before any UI change.
- `_documentacion/arquitectura_navegacion.md` — navigation architecture.
- `_documentacion/especificacion_motor_social.md` — social features (Conocidos, Grupos).
- `CLAUDE.md` — full project context (this file is a compact subset).
