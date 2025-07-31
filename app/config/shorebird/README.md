# Shorebird

## Installation

CLI

```bash
curl --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/shorebirdtech/install/main/install.sh -sSf | bash

# Login
shorebird login

shorebird init

shorebird release ios

# Run this command and fix the problems
shorebird doctor

shorebird release ios --flavor development --flutter-version 3.27.3 '--' --target lib/main_development.dart --dart-define-from-file env.json

shorebird preview ios -- --flavor development --flutter-version 3.27.3 --target lib/main_development.dart --dart-define-from-file env.json
```

