# Bluejean

## Backend

Add .env, copy the env.example

```
composer install
php artisan key:generate
php artisan storage:link
php artisan migrate
php artisan serve
```

### Docker

```bash
cd backend
make deploy-dev
```

To deploy to production locally (run with prod ports):

```bash
cd backend
make deploy-prod
```

To stop the environments:

```bash
cd backend
make down-dev
# or
make down-prod
```

To build and push the image to a registry:

```bash
cd backend
make push REGISTRY_URL=<your-registry>
```

## App

```
fvm flutter pub get

./config/firebase/configure_firebase.sh \
    --project="" \
    --ios-bundle-id="com.santiagoducos" \
    --android-package-name="com.santiagoducos" \
    --env="prod"
```

## Project

Rename the ```bluejean.code-workspace```

## Create user admin

```
php artisan user-admin:create --name="Test Admin" --email="[EMAIL_ADDRESS]" --password="[PASSWORD]"
```