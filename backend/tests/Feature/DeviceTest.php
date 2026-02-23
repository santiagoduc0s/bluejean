<?php

use App\Models\Device;
use App\Models\User;

function authHeader(User $user): array
{
    $token = $user->createToken('auth_token')->plainTextToken;
    return ['Authorization' => "Bearer $token"];
}

it('creates a new device for authenticated user', function () {
    $user = User::factory()->create();

    $this->withHeaders(authHeader($user))
        ->postJson('/api/v1/devices', [
            'identifier' => 'device-123',
            'model' => 'iPhone 15',
            'fcm_token' => 'token-abc',
        ])
        ->assertSuccessful()
        ->assertJson([
            'data' => [
                'identifier' => 'device-123',
                'model' => 'iPhone 15',
                'fcm_token' => 'token-abc',
            ],
        ]);

    $this->assertDatabaseHas('devices', [
        'identifier' => 'device-123',
        'user_id' => $user->id,
    ]);
});

it('updates existing device on upsert', function () {
    $user = User::factory()->create();
    Device::factory()->forUser($user)->create([
        'identifier' => 'device-123',
        'model' => 'Old Model',
        'fcm_token' => 'old-token',
    ]);

    $this->withHeaders(authHeader($user))
        ->postJson('/api/v1/devices', [
            'identifier' => 'device-123',
            'model' => 'New Model',
            'fcm_token' => 'new-token',
        ])
        ->assertOk()
        ->assertJson([
            'data' => [
                'model' => 'New Model',
                'fcm_token' => 'new-token',
            ],
        ]);

    $this->assertDatabaseCount('devices', 1);
});

it('re-links device to new user on upsert', function () {
    $user1 = User::factory()->create();
    $user2 = User::factory()->create();

    Device::factory()->forUser($user1)->create(['identifier' => 'device-123']);

    $this->withHeaders(authHeader($user2))
        ->postJson('/api/v1/devices', [
            'identifier' => 'device-123',
            'model' => 'iPhone 15',
        ])
        ->assertOk();

    $this->assertDatabaseHas('devices', [
        'identifier' => 'device-123',
        'user_id' => $user2->id,
    ]);
});

it('lists user devices', function () {
    $user = User::factory()->create();
    Device::factory()->forUser($user)->count(3)->create();
    Device::factory()->create(); // another user's device

    $this->actingAs($user)
        ->getJson('/api/v1/devices')
        ->assertOk()
        ->assertJsonCount(3, 'data');
});

it('unlinks a device', function () {
    $user = User::factory()->create();
    $device = Device::factory()->forUser($user)->create(['identifier' => 'device-123']);

    $this->actingAs($user)
        ->postJson('/api/v1/devices/unlink', [
            'identifier' => 'device-123',
        ])
        ->assertOk();

    $this->assertDatabaseHas('devices', [
        'id' => $device->id,
        'user_id' => null,
        'personal_access_tokens_id' => null,
        'fcm_token' => null,
    ]);
});

it('cannot unlink another user device', function () {
    $user1 = User::factory()->create();
    $user2 = User::factory()->create();
    Device::factory()->forUser($user1)->create(['identifier' => 'device-123']);

    $this->actingAs($user2)
        ->postJson('/api/v1/devices/unlink', [
            'identifier' => 'device-123',
        ])
        ->assertNotFound();
});

it('validates required fields on upsert', function () {
    $user = User::factory()->create();

    $this->actingAs($user)
        ->postJson('/api/v1/devices', [])
        ->assertUnprocessable();
});

it('requires auth for device routes', function () {
    $this->postJson('/api/v1/devices')->assertUnauthorized();
    $this->getJson('/api/v1/devices')->assertUnauthorized();
    $this->postJson('/api/v1/devices/unlink')->assertUnauthorized();
});
