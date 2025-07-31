lint:
	dart fix --apply
	dart format .
	fvm flutter analyze

runner:
	dart run build_runner build

clean:
	fvm flutter clean

pubget:
	fvm flutter pub get