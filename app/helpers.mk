lint:
	fvm dart fix --apply
	fvm dart format .
	fvm flutter analyze

runner:
	fvm dart run build_runner build

clean:
	fvm flutter clean

pubget:
	fvm flutter pub get

lang:
	fvm flutter gen-l10n

devices:
	fvm flutter devices