<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Contract\Messaging;
use App\Repositories\Contracts\MessagingRepositoryInterface;
use App\Repositories\MessagingRepository;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // Register Firebase Factory
        $this->app->singleton(Factory::class, function ($app) {
            $serviceAccountPath = config('firebase.service_account_path');

            // Skip Firebase initialization if service account file doesn't exist
            if (!file_exists($serviceAccountPath)) {
                return null;
            }

            return (new Factory)->withServiceAccount($serviceAccountPath);
        });

        // Register Firebase Messaging
        $this->app->singleton(Messaging::class, function ($app) {
            $factory = $app->make(Factory::class);

            if (!$factory) {
                throw new \Exception('Firebase is not properly configured. Please check your eservice account file.');
            }

            return $factory->createMessaging();
        });

        // Register MessagingRepository
        $this->app->bind(MessagingRepositoryInterface::class, MessagingRepository::class);
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
