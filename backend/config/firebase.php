<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Firebase Service Account Key
    |--------------------------------------------------------------------------
    |
    | Path to the Firebase service account JSON file. This file contains
    | the credentials needed to authenticate with Firebase services.
    |
    */

    'service_account_path' => base_path('serviceAccountKey.json'),

    /*
    |--------------------------------------------------------------------------
    | Firebase Project Configuration
    |--------------------------------------------------------------------------
    |
    | Additional Firebase project configuration options.
    |
    */

    'project_id' => env('FIREBASE_PROJECT_ID'),

    /*
    |--------------------------------------------------------------------------
    | Firebase Database URL
    |--------------------------------------------------------------------------
    |
    | The Firebase Realtime Database URL (optional).
    |
    */

    'database_url' => env('FIREBASE_DATABASE_URL'),

    /*
    |--------------------------------------------------------------------------
    | Firebase Storage Bucket
    |--------------------------------------------------------------------------
    |
    | The Firebase Storage bucket name (optional).
    |
    */

    'storage_bucket' => env('FIREBASE_STORAGE_BUCKET'),
];