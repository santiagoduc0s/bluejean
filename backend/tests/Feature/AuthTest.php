<?php

use App\Models\User;
use Laravel\Sanctum\Sanctum;

it('signs up a new user', function () {
    $response = $this->postJson('/api/v1/auth/sign-up', [
        'email' => 'test@example.com',
        'password' => 'password123',
    ]);

    $response->assertNoContent();
    $this->assertDatabaseHas('users', ['email' => 'test@example.com']);
});

it('fails sign up with duplicate email', function () {
    User::factory()->create(['email' => 'test@example.com']);

    $this->postJson('/api/v1/auth/sign-up', [
        'email' => 'test@example.com',
        'password' => 'password123',
    ])->assertUnprocessable();
});

it('fails sign up with short password', function () {
    $this->postJson('/api/v1/auth/sign-up', [
        'email' => 'test@example.com',
        'password' => 'short',
    ])->assertUnprocessable();
});

it('signs in a verified user', function () {
    User::factory()->create([
        'email' => 'test@example.com',
        'password' => 'password123',
    ]);

    $response = $this->postJson('/api/v1/auth/sign-in', [
        'email' => 'test@example.com',
        'password' => 'password123',
    ]);

    $response->assertOk()->assertJsonStructure(['token']);
});

it('fails sign in with wrong password', function () {
    User::factory()->create([
        'email' => 'test@example.com',
        'password' => 'password123',
    ]);

    $this->postJson('/api/v1/auth/sign-in', [
        'email' => 'test@example.com',
        'password' => 'wrongpassword',
    ])->assertUnprocessable();
});

it('fails sign in with unverified email', function () {
    User::factory()->unverified()->create([
        'email' => 'test@example.com',
        'password' => 'password123',
    ]);

    $this->postJson('/api/v1/auth/sign-in', [
        'email' => 'test@example.com',
        'password' => 'password123',
    ])->assertUnprocessable();
});

it('signs out the current user', function () {
    $user = User::factory()->create();
    $token = $user->createToken('auth_token')->plainTextToken;

    $this->withHeader('Authorization', "Bearer $token")
        ->postJson('/api/v1/auth/sign-out')
        ->assertNoContent();

    $this->assertDatabaseCount('personal_access_tokens', 0);
});

it('gets the current user', function () {
    $user = User::factory()->create();

    $this->actingAs($user)
        ->getJson('/api/v1/auth/me')
        ->assertOk()
        ->assertJson([
            'data' => [
                'id' => $user->id,
                'email' => $user->email,
            ],
        ]);
});

it('updates the current user', function () {
    $user = User::factory()->create();

    $this->actingAs($user)
        ->putJson('/api/v1/auth/me', ['name' => 'New Name'])
        ->assertOk()
        ->assertJson([
            'data' => ['name' => 'New Name'],
        ]);

    $this->assertDatabaseHas('users', ['id' => $user->id, 'name' => 'New Name']);
});

it('deletes the current user account', function () {
    $user = User::factory()->create();

    $this->actingAs($user)
        ->deleteJson('/api/v1/auth/me')
        ->assertNoContent();

    $this->assertDatabaseMissing('users', ['id' => $user->id]);
});

it('deletes account and unlinks devices', function () {
    $user = User::factory()->create();
    $device = \App\Models\Device::factory()->forUser($user)->create();

    $this->actingAs($user)
        ->deleteJson('/api/v1/auth/me')
        ->assertNoContent();

    $this->assertDatabaseMissing('users', ['id' => $user->id]);
    $this->assertDatabaseHas('devices', [
        'id' => $device->id,
        'user_id' => null,
        'fcm_token' => null,
    ]);
});

it('returns 204 for forgot password regardless of email existence', function () {
    $this->postJson('/api/v1/auth/forgot-password', [
        'email' => 'nonexistent@example.com',
    ])->assertNoContent();
});

it('requires auth for protected routes', function () {
    $this->getJson('/api/v1/auth/me')->assertUnauthorized();
    $this->putJson('/api/v1/auth/me')->assertUnauthorized();
    $this->deleteJson('/api/v1/auth/me')->assertUnauthorized();
    $this->postJson('/api/v1/auth/sign-out')->assertUnauthorized();
});
