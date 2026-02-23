<?php

use App\Models\User;

it('completes a full user lifecycle', function () {
    // Sign up
    $this->postJson('/api/v1/auth/sign-up', [
        'email' => 'test@example.com',
        'password' => 'password123',
    ])->assertNoContent();

    // Can't sign in before verification
    $this->postJson('/api/v1/auth/sign-in', [
        'email' => 'test@example.com',
        'password' => 'password123',
    ])->assertUnprocessable();

    // Verify email
    $user = User::where('email', 'test@example.com')->first();
    $user->markEmailAsVerified();

    // Sign in
    $token = $this->postJson('/api/v1/auth/sign-in', [
        'email' => 'test@example.com',
        'password' => 'password123',
    ])->assertOk()->json('token');

    $headers = ['Authorization' => "Bearer $token"];

    // Update profile
    $this->withHeaders($headers)
        ->putJson('/api/v1/auth/me', ['name' => 'Test User'])
        ->assertOk()
        ->assertJson(['data' => ['name' => 'Test User']]);

    // Register device
    $this->withHeaders($headers)
        ->postJson('/api/v1/devices', [
            'identifier' => 'device-abc',
            'model' => 'iPhone 15',
            'fcm_token' => 'fcm-token-123',
        ])->assertSuccessful();

    // List devices
    $this->withHeaders($headers)
        ->getJson('/api/v1/devices')
        ->assertOk()
        ->assertJsonCount(1, 'data');

    // Unlink device
    $this->withHeaders($headers)
        ->postJson('/api/v1/devices/unlink', [
            'identifier' => 'device-abc',
        ])->assertOk();

    // Sign out
    $this->withHeaders($headers)
        ->postJson('/api/v1/auth/sign-out')
        ->assertNoContent();

    // Token is invalidated
    $this->assertDatabaseCount('personal_access_tokens', 0);
});
