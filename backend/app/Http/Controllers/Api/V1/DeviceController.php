<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\DeviceResource;
use App\Models\Device;
use Illuminate\Http\Request;

class DeviceController extends Controller
{
    public function upsert(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string|max:255',
            'model' => 'required|string|max:255',
            'fcm_token' => 'nullable|string|max:255',
        ]);

        $device = Device::updateOrCreate(
            ['identifier' => $request->input('identifier')],
            [
                'model' => $request->input('model'),
                'fcm_token' => $request->input('fcm_token'),
                'user_id' => $request->user()->id,
                'personal_access_tokens_id' => $request->user()->currentAccessToken()->id,
            ],
        );

        return DeviceResource::make($device);
    }

    public function unlinkUser(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string|max:255',
            'invalidate_token' => 'nullable|boolean',
        ]);

        $device = $request->user()->devices()
            ->where('identifier', $request->input('identifier'))
            ->firstOrFail();

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

    public function getDevices(Request $request)
    {
        $devices = $request->user()->devices;

        return DeviceResource::collection($devices);
    }
}
