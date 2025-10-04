build-ios-prod-ipa:
	make prod
	fvm flutter build ipa --obfuscate --split-debug-info --release --flavor production --target lib/main_production.dart --dart-define-from-file env.json

build-android-prod:
	make prod
	fvm flutter build appbundle --flavor production --target lib/main_production.dart --dart-define-from-file env.json

build-web-prod:
	make prod
	fvm flutter build web --release --target lib/main_production.dart --dart-define-from-file env.json

deploy-firebase-hosting:
	firebase deploy --only hosting

shorebird-release-ios-prod:
	make prod
	shorebird release ios --flavor production --target lib/main_production.dart --dart-define-from-file env.json

shorebird-preview-ios-prod:
	make prod
	shorebird preview ios --device-id $(DEVICE_ID) -- --flavor production --target lib/main_production.dart --dart-define-from-file env.json

shorebird-patch-ios-prod:
	make prod
	shorebird patch ios --flavor production --target lib/main_production.dart --dart-define-from-file env.json

shorebird-patch-ios-prod-version:
	make prod
	shorebird patch ios --flavor production --target lib/main_production.dart --dart-define-from-file env.json --release-version=$(VERSION)

shorebird-release-android-prod:
	make prod
	shorebird release android -- --flavor production --target lib/main_production.dart --dart-define-from-file env.json

shorebird-preview-android-prod:
	make prod
	shorebird preview android --device-id $(DEVICE_ID) -- --flavor production --target lib/main_production.dart --dart-define-from-file env.json

shorebird-patch-android-prod:
	make prod
	shorebird patch android -- --flavor production --target lib/main_production.dart --dart-define-from-file env.json

shorebird-patch-android-prod-version:
	make prod
	shorebird patch android -- --flavor production --target lib/main_production.dart --dart-define-from-file env.json --release-version=$(VERSION)