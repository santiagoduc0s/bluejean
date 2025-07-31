build-ios-prod-ipa:
	make prod
	fvm flutter build ipa --obfuscate --split-debug-info --release --flavor production --target lib/main_production.dart --dart-define-from-file env.json

build-android-prod:
	make prod
	fvm flutter build appbundle --flavor production --target lib/main_production.dart --dart-define-from-file env.json

build-web-prod:
	make prod
	fvm flutter build web --release --target lib/main_production.dart --dart-define-from-file env.json
