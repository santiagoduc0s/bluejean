# Bluejean

## Backend

Add .env, copy the env.example
Run ```php artisan key:generate```
- To use sign in with google set the ```GOOGLE_CLIENT_ID```

```
composer install
php artisan storage:link
php artisan migrate
php artisan serve # or herd link projectname -> then set the APP_URL
```

Add serviceAccountKey.json to the root

## App

```
fvm flutter pub get

./config/firebase/configure_firebase.sh \
    --project="" \
    --ios-bundle-id="com.santiagoducos" \
    --android-package-name="com.santiagoducos" \
    --env="prod"
```

Add to the ```<env>/env.json```
```
  "BASE_URL": "http://backend.test", # your backend url
  "SERVER_CLIENT_ID": "" # sign in with google
```

## Project

Rename the ```bluejean.code-workspace```