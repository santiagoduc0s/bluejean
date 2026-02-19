# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter mobile application with Laravel backend.

- `app/` - Flutter mobile application (Flutter 3.35.4 via fvm)
- `backend/` - Laravel 12 API backend

## Development Commands

### Flutter App (app/)

All Flutter commands must use `fvm` prefix. Run make targets from `app/` directory.

```bash
# Environment switching (copies env-specific config files)
make dev / make stg / make prod

# Setup
fvm flutter pub get          # Install dependencies
make runner                  # Run build_runner (code generation for assets/l10n)

# Testing
fvm flutter test --coverage --test-randomize-ordering-seed random
fvm flutter test path/to/test_file.dart   # Run single test

# Quality
make lint                    # dart fix + format + analyze (uses very_good_analysis)

# Localization
fvm flutter gen-l10n         # Generate from ARB files in lib/l10n/

# Building
make build-android-prod      # Android production APK
make build-ios-prod-ipa      # iOS production IPA
make build-web-prod          # Web production
```

### Laravel Backend (backend/)

```bash
composer install             # Install PHP dependencies
php artisan storage:link     # Create storage symlink (one time)
php artisan migrate          # Run database migrations
php artisan serve            # Start development server

# Testing (PestPHP)
php artisan test             # Run all tests
php artisan test --filter=TestName  # Run specific test

# Admin panel
php artisan user-admin:create --name="Name" --email="email" --password="pass"
```

**Required setup:** Place `serviceAccountKey.json` (Firebase) in backend root.

## Architecture Overview

### Flutter App Architecture

Clean Architecture with four layers:

- **Core (`lib/core/`)** - Config, DI, extensions, theme, utilities
- **Domain (`lib/domain/`)** - Entities, repository interfaces, use cases, enums
- **Data (`lib/data/`)** - Models (JSON mapping), repository implementations, device/storage/permission services
- **Presentation (`lib/ui/`)** - Feature-based screens and widgets

**Dependency Injection:** GetIt service locator (`AppProvider` in `lib/core/dependencies/`) registers all services, repositories, use cases, and notifiers. Provider package is used for state management (ChangeNotifier) at the widget tree level, not for DI.

**State Management:** ChangeNotifier classes (AuthNotifier, PreferenceNotifier) exposed via Provider. Global session state via `AppSession.instance` singleton.

**Navigation:** GoRouter with StatefulShellRoute for bottom/rail navigation. Routes redirect based on AuthNotifier authentication state.

**HTTP:** Custom `ApiClient` with automatic token management, 401 handling, and request logging.

### Laravel Backend Architecture

API-first Laravel with versioned routes (`/api/v1/`). Authentication via Laravel Sanctum.

- `app/Http/Controllers/Api/V1/` - API controllers
- `app/Policies/` - Authorization policies
- `app/Http/Resources/` - Response transformers
- `app/Services/` - OAuth services (Apple, Google)
- `app/Filament/` - Admin panel (Filament v3)
- `routes/api_v1.php` - All API route definitions

### Database Schema

- Users have optional preferences (one-to-one)
- Devices have required preferences (one-to-one)
- Devices optionally belong to a user (anonymous device support)
- Multiple auth providers per user via `user_providers`
- Firebase notifications target users or devices

## API Design Patterns

Dual-context access pattern — repositories auto-select endpoints based on auth state:

- **Anonymous (device-based):** `/devices/by-identifier`, `/preferences/by-device` — requires device identifier
- **Authenticated (user-based):** `/devices/me`, `/preferences/me` — requires Bearer token

## Environment Configuration

Three environments (dev/stg/prod) in `app/environments/`, each with Firebase config, env.json (BASE_URL, SERVER_CLIENT_ID), and platform manifests. Switching environments (`make dev/stg/prod`) copies these files into place.

## Key Patterns

- Always use `fvm flutter` instead of plain `flutter`
- Code generation required after changing assets or adding localizations (`make runner`)
- Repositories choose anonymous vs authenticated endpoints automatically
- Use `AppSession.instance` for global session access in repositories
- Shorebird integration for OTA code patching (see `app/builds.mk`)
- API responses use Laravel Resource classes for consistent formatting
