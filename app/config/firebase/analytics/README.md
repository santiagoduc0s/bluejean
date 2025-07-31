# Firebase Analytics

## Install Firebase Analytics

```bash
fvm flutter pub add firebase_analytics
```

## Bootstrap

```dart
await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
    Env.environment == 'prod',
);
```

## Observe routes

```dart
GoRouter(
    observers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    // ...
);
```
