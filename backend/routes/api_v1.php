<?php

use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\FileController;
use App\Http\Controllers\Api\V1\DeviceController;
use Illuminate\Support\Facades\Route;


Route::prefix('auth')->group(function () {
    Route::post('/sign-up', [AuthController::class, 'signUp']);
    Route::post('/sign-in', [AuthController::class, 'signIn']);
    Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
});

Route::prefix('files')->group(function () {
    Route::post('/upload', [FileController::class, 'upload']);
});

Route::middleware('auth:sanctum')->group(function () {

    Route::prefix('auth')->group(function () {
        Route::post('/sign-out', [AuthController::class, 'signOut']);
        Route::get('/me', [AuthController::class, 'currentUser']);
        Route::put('/me', [AuthController::class, 'update']);
        Route::delete('/me', [AuthController::class, 'deleteAccount']);
    });

    Route::prefix('devices')->group(function () {
        Route::post('/', [DeviceController::class, 'upsert']);
        Route::post('/unlink', [DeviceController::class, 'unlinkUser']);
        Route::get('/', [DeviceController::class, 'getDevices']);
    });

});
