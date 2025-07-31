# Android

## Finger Print
```
# Generate key
keytool -genkeypair -v \
  -keystore android/app/release-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias password

# Release keystore:
keytool -list -v \
  -keystore android/app/release-keystore.jks \
  -alias password \
  -storepass password-password \
  -keypass password-password

# Debug keystore:
keytool -list -v \
  -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android
```