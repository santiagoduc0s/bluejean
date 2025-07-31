## Installation

Set the images that you want to use in each platform:
- ```config/app_icon/android```
- ```config/app_icon/ios```
- ```config/app_icon/web```

### Android

```
fvm dart run icons_launcher:create --path android_icons_launcher.yaml --flavor development
fvm dart run icons_launcher:create --path android_icons_launcher.yaml --flavor staging
fvm dart run icons_launcher:create --path android_icons_launcher.yaml --flavor main
```

### iOS

1. Go to ```ios/Runner/Assets.xcassets```
2. Delete ```AppIcon-dev.appiconset```, ```AppIcon-stg.appiconset```, ```AppIcon.appiconset```
3. 
```
fvm dart run icons_launcher:create --path ios_icons_launcher.yaml --flavor AppIcon-dev.appiconset
fvm dart run icons_launcher:create --path ios_icons_launcher.yaml --flavor AppIcon-stg.appiconset
fvm dart run icons_launcher:create --path ios_icons_launcher.yaml --flavor AppIcon.appiconset
```
4. Go to ```ios/Runner/Assets.xcassets``` and rename
```
AppIcon-dev.appiconsetAppIcon.appiconset -> AppIcon-dev.appiconset
AppIcon-stg.appiconsetAppIcon.appiconset -> AppIcon-stg.appiconset
AppIcon.appiconsetAppIcon.appiconset -> AppIcon.appiconset
```

### Web

```
fvm dart run icons_launcher:create --path web_icons_launcher.yaml
```