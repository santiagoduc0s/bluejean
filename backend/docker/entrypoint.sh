#!/bin/bash
set -e

cd /var/www

# Install dependencies
if [ "$APP_ENV" = "production" ]; then
    composer install --no-dev --optimize-autoloader --no-interaction
else
    composer install --no-interaction
fi

# Run migrations
php artisan migrate --force

# Create storage symlink (idempotent)
php artisan storage:link 2>/dev/null || true

# Production optimizations
if [ "$APP_ENV" = "production" ]; then
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
fi

# Execute the main container command
exec "$@"
