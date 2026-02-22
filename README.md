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

- **Makefile**: Shortcuts for deployment and teardown.
    - `make deploy-dev`:  Runs dev setup (port 8002/3307).
    - `make deploy-prod`: Runs prod setup (port 8000/3306) with Octane.

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
docker exec bluejean-app-dev php artisan user-admin:create --name="Test Admin" --email="admin@admin.com" --password="12341234"
```