# Firebase

## Link with a project and the environment

```bash
./config/firebase/configure_firebase.sh \
    --project="project-id" \
    --ios-bundle-id="com.company.app" \
    --android-package-name="com.company.app" \
    --env="prod"
```

## Install firebase_core

```bash
fvm flutter pub add firebase_core
```

## Bootstrap

```dart
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
```