# Contributing to Orchom

First off, thank you for considering contributing! 🎉 It's people like you who make Orchom better for every player of Rami Tunisien.

## 🪜 Ways to contribute

- 🐛 **Report a bug** — open an [issue](../../issues) with the bug report template.
- 💡 **Suggest a feature** — describe the feature and *why* it's useful.
- 🌍 **Add a translation** — copy `lib/l10n/app_en.arb`, translate it, and open a PR (see below).
- 🧪 **Improve tests or docs** — always welcome.
- 💻 **Fix a bug or implement a feature** — follow the workflow below.

## 🛠️ Development setup

```bash
# 1. Fork the repo, then clone your fork
git clone https://github.com/YOUR_USERNAME/orchom.git
cd orchom

# 2. Add the upstream remote (to sync later)
git remote add upstream https://github.com/ORIGINAL_OWNER/orchom.git

# 3. Install dependencies
flutter pub get

# 4. Make sure everything passes before you start
flutter analyze
flutter test
```

## 🌿 Workflow

1. Create a branch from `main` with a descriptive name:
   ```bash
   git checkout -b feature/quick-buttons-editor
   ```
2. Make your changes. Keep commits small and messages meaningful
   (`feat: …`, `fix: …`, `docs: …`, `refactor: …`, `test: …`).
3. Run the quality gates — **both must pass**:
   ```bash
   flutter analyze
   flutter test
   ```
4. Push and open a **Pull Request** describing what you did and how to test it.

### Tiered code style

Orchom enforces the [`flutter_lints`](https://pub.dev/packages/flutter_lints) set. Key conventions:

- **Layer discipline:** business logic belongs in `lib/domain` (pure Dart, no Flutter imports), platform specifics in `lib/data`, UI in `lib/presentation`. Domain code must stay unit-testable without a device.
- **New user-facing strings** go into both ARB files (`app_en.arb` **and** `app_ar.arb`). Never hard-code user-facing text.
- **Theming:** use the tokens in `lib/presentation/theme` (`AppColors`, `AppSpacing`, `AppTextStyles`…) instead of raw values.
- **Reusable widgets** follow the `Orchom*` naming convention in `lib/presentation/widgets`.

## 🌍 Adding a language

1. Copy `lib/l10n/app_en.arb` to `app_<locale>.arb` (e.g. `app_fr.arb`).
2. Translate the **values** only — keep keys and metadata (`@key`) untouched.
3. Run `flutter gen-l10n` and make sure the app builds.
4. Add the locale to the Flutter project settings if needed, and open a PR.

## 🐛 Reporting a bug

A good bug report includes:

1. What you did and what you expected.
2. What actually happened (with a screenshot if visual).
3. Platform (Android/iOS/desktop), OS version, and app version.
4. Steps to reproduce — the shorter, the better.

## 📜 Code of conduct

By participating in this project you agree to abide by the [Code of Conduct](CODE_OF_CONDUCT.md).

---

Again — thank you! Your PR should be reviewed quickly. 🚀
