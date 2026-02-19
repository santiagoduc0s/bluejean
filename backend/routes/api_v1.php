<?php

use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\FileController;
use App\Http\Controllers\Api\V1\DeviceController;
use App\Http\Controllers\Api\V1\LogController;
use App\Http\Controllers\Api\V1\PreferenceController;
use App\Http\Controllers\Api\V1\SupportTicketController;
use Illuminate\Support\Facades\Route;


Route::prefix('auth')->group(function () {
    Route::post('/sign-up', [AuthController::class, 'signUp']);
    Route::post('/sign-in', [AuthController::class, 'signIn']);
    Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
});

Route::prefix('devices')->group(function () {
    Route::get('/by-identifier', [DeviceController::class, 'getCurrentDevice']);
    Route::post('/', [DeviceController::class, 'store']);
    Route::put('/by-identifier', [DeviceController::class, 'update']);
});

Route::prefix('preferences')->group(function () {
    Route::get('/by-device', [PreferenceController::class, 'getCurrentDevicePreference']);
    Route::put('/by-device', [PreferenceController::class, 'updateDevice']);
});

Route::prefix('support-tickets')->middleware('throttle:20,1440')->group(function () {
    Route::post('/', [SupportTicketController::class, 'store']);
});

Route::prefix('files')->group(function () {
    Route::post('/upload', [FileController::class, 'upload']);
});

Route::prefix('logs')->group(function () {
    Route::post('/', [LogController::class, 'store']);
});


Route::middleware('auth:sanctum')->group(function () {

    Route::prefix('auth')->group(function () {
        Route::post('/sign-out', [AuthController::class, 'signOut']);
        Route::get('/me', [AuthController::class, 'currentUser']);
        Route::put('/me', [AuthController::class, 'update']);
        Route::delete('/me', [AuthController::class, 'deleteAccount']);
    });

    Route::prefix('devices')->group(function () {
        Route::get('/me', [DeviceController::class, 'getCurrentAuthDevice']);
        Route::put('/me', [DeviceController::class, 'updateAuthDevice']);
        Route::get('/', [DeviceController::class, 'getDevices']);
        Route::post('/link', [DeviceController::class, 'linkToUser']);
        Route::post('/unlink', [DeviceController::class, 'unlinkUser']);
    });

    Route::prefix('preferences')->group(function () {
        Route::get('/me', [PreferenceController::class, 'getCurrentAuthPreference']);
        Route::put('/me', [PreferenceController::class, 'updateAuth']);
    });

});
