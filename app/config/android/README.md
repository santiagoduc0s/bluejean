# Android

## Finger Print
```
# Generate key
keytool -genkeypair -v \
  -keystore android/app/release-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias password \
  -storepass "YOUR_KEYSTORE_PASSWORD" \
  -keypass "YOUR_KEY_PASSWORD" \
  -dname "CN=Your App Name, OU=Your Organization, O=Your Company, L=Your City, ST=Your State, C=Your Country"

# Create key.properties file in android/ directory:
# storePassword=YOUR_KEYSTORE_PASSWORD
# keyPassword=YOUR_KEY_PASSWORD
# keyAlias=YOUR_KEY_ALIAS
# storeFile=release-keystore.jks

# Release keystore:
keytool -list -v \
  -keystore android/app/release-keystore.jks \
  -alias password \
  -storepass "YOUR_KEYSTORE_PASSWORD" \
  -keypass "YOUR_KEY_PASSWORD"

# Debug keystore:
keytool -list -v \
  -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android
```