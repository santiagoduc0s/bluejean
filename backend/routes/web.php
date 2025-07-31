<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\AuthController;
use Illuminate\Http\Request;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/email/verify/{id}/{hash}', [AuthController::class, 'verifyEmail'])
    ->middleware('signed')
    ->name('verification.verify');

Route::get('/password/reset/{token}', function (string $token, Request $request) {
    return view('mails.reset-password', [
        'token' => $token,
        'email' => $request->query('email')
    ]);
})->middleware('guest')->name('password.reset');

Route::post('/password/reset', [AuthController::class, 'resetPassword'])
    ->middleware('guest')
    ->name('password.update');
