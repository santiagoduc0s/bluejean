<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\DeviceResource;
use App\Models\Device;
use App\Models\Preference;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class DeviceController extends Controller
{
    use AuthorizesRequests;

    public function getCurrentDevice(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string|max:255',
        ]);

        $device = Device::where('identifier', $request->query('identifier'))->firstOrFail();

        if ($device->user_id != null) {
            $this->authorize('isTheOwner', $device);
        }

        return DeviceResource::make($device);
    }

    public function store(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string|max:255|unique:devices,identifier',
            'model' => 'required|string|max:255',
        ]);

        $preference = Preference::create();

        $device = Device::create(
            [
                ...$request->only([
                    'identifier',
                    'model',
                ]),
                'preference_id' => $preference->id,
            ],
        );

        return DeviceResource::make($device);
    }

    public function update(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string|max:255',
            'fcm_token' => 'nullable|string|max:255',
        ]);

        $device = Device::where('identifier', $request->input('identifier'))->firstOrFail();

        if ($device->user_id != null) {
            $this->authorize('isTheOwner', $device);
        }

        $device->update($request->only(['fcm_token']));

        return DeviceResource::make($device);
    }

    public function linkToUser(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string|max:255',
        ]);

        $device = Device::where('identifier', $request->input('identifier'))->firstOrFail();

        if ($device->user_id != null) {
            $this->authorize('isTheOwner', $device);
        }

        $device->update([
            'user_id' => $request->user()->id,
            'personal_access_tokens_id' => $request->user()->currentAccessToken()->id
        ]);

        if (!$request->user()->preference_id) {
            // Check if device's preference is already linked to another user
            // This can happen when:
            // 1. User A signs up and links device (gets device's preference)
            // 2. User A signs out (device unlinks but keeps preference linked to User A)
            // 3. User B tries to sign in on same device (preference conflict!)
            $devicePreference = $device->preference;
            $preferenceIsLinkedToAnotherUser = User::where('preference_id', $device->preference_id)
                ->where('id', '!=', $request->user()->id)
                ->exists();

            if ($preferenceIsLinkedToAnotherUser) {
                $newPreference = Preference::create($devicePreference->only([
                    'theme',
                    'language',
                    'text_scaler',
                    'notifications_are_enabled',
                ]));

                $request->user()->update([
                    'preference_id' => $newPreference->id,
                ]);

                $device->update([
                    'preference_id' => $newPreference->id,
                ]);
            } else {
                $request->user()->update([
                    'preference_id' => $device->preference_id,
                ]);
            }
        }

        return DeviceResource::make($device);
    }

    public function unlinkUser(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string|max:255',
            'invalidate_token' => 'nullable|boolean',
        ]);

        $device = Device::where('identifier', $request->input('identifier'))->firstOrFail();

        if ($device->user_id != null) {
            $this->authorize('isTheOwner', $device);
        }

        if ($request->input('invalidate_token', false)) {
            $device->accessToken?->delete();
        }

        $device->update([
            'user_id' => null,
            'personal_access_tokens_id' => null,
            'fcm_token' => null,
        ]);

        return DeviceResource::make($device);
    }

    public function getCurrentAuthDevice(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string|max:255',
        ]);

        $device = $request->user()->devices()
            ->where('identifier', $request->query('identifier'))
            ->firstOrFail();

        return DeviceResource::make($device);
    }

    public function updateAuthDevice(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string|max:255',
            'fcm_token' => 'nullable|string|max:255',
        ]);

        $device = $request->user()->devices()
            ->where('identifier', $request->input('identifier'))
            ->firstOrFail();

        $device->update($request->only(['fcm_token']));

        return DeviceResource::make($device);
    }

    public function getDevices(Request $request)
    {
        $devices = $request->user()->devices;

        return DeviceResource::collection($devices);
    }
}
