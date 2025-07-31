dev:
	@if [ -f environments/dev/firebase_options.dart ]; then cp -f environments/dev/firebase_options.dart lib/firebase_options.dart; fi
	@if [ -f environments/dev/firebase.json ]; then cp -f environments/dev/firebase.json firebase.json; fi
	@if [ -f environments/dev/GoogleService-Info.plist ]; then cp -f environments/dev/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist; fi
	@if [ -f environments/dev/Info.plist ]; then cp -f environments/dev/Info.plist ios/Runner/Info.plist; fi
	@if [ -f environments/dev/google-services.json ]; then cp -f environments/dev/google-services.json android/app/google-services.json; fi
	@if [ -f environments/dev/env.json ]; then cp -f environments/dev/env.json env.json; fi
	@if [ -f environments/dev/AndroidManifest.xml ]; then cp -f environments/dev/AndroidManifest.xml android/app/src/main/AndroidManifest.xml; fi
	@if [ -f environments/dev/strings.xml ]; then cp -f environments/dev/strings.xml android/app/src/main/res/values/strings.xml; fi

stg:
	@if [ -f environments/stg/firebase_options.dart ]; then cp -f environments/stg/firebase_options.dart lib/firebase_options.dart; fi
	@if [ -f environments/stg/firebase.json ]; then cp -f environments/stg/firebase.json firebase.json; fi
	@if [ -f environments/stg/GoogleService-Info.plist ]; then cp -f environments/stg/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist; fi
	@if [ -f environments/stg/Info.plist ]; then cp -f environments/stg/Info.plist ios/Runner/Info.plist; fi
	@if [ -f environments/stg/google-services.json ]; then cp -f environments/stg/google-services.json android/app/google-services.json; fi
	@if [ -f environments/stg/env.json ]; then cp -f environments/stg/env.json env.json; fi
	@if [ -f environments/stg/AndroidManifest.xml ]; then cp -f environments/stg/AndroidManifest.xml android/app/src/main/AndroidManifest.xml; fi
	@if [ -f environments/stg/strings.xml ]; then cp -f environments/stg/strings.xml android/app/src/main/res/values/strings.xml; fi

prod:
	@if [ -f environments/prod/firebase_options.dart ]; then cp -f environments/prod/firebase_options.dart lib/firebase_options.dart; fi
	@if [ -f environments/prod/firebase.json ]; then cp -f environments/prod/firebase.json firebase.json; fi
	@if [ -f environments/prod/GoogleService-Info.plist ]; then cp -f environments/prod/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist; fi
	@if [ -f environments/prod/Info.plist ]; then cp -f environments/prod/Info.plist ios/Runner/Info.plist; fi
	@if [ -f environments/prod/google-services.json ]; then cp -f environments/prod/google-services.json android/app/google-services.json; fi
	@if [ -f environments/prod/env.json ]; then cp -f environments/prod/env.json env.json; fi
	@if [ -f environments/prod/AndroidManifest.xml ]; then cp -f environments/prod/AndroidManifest.xml android/app/src/main/AndroidManifest.xml; fi
	@if [ -f environments/prod/strings.xml ]; then cp -f environments/prod/strings.xml android/app/src/main/res/values/strings.xml; fi
