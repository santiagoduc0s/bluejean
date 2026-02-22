<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\PreferenceResource;
use App\Models\Device;
use Illuminate\Http\Request;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class PreferenceController extends Controller
{
    use AuthorizesRequests;

    public function getCurrentDevicePreference(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string|max:255',
        ]);

        $device = Device::where('identifier', $request->query('identifier'))->firstOrFail();

        $this->authorize('canSeePreference', $device);

        $preference = $device->preference;

        return PreferenceResource::make($preference);
    }

    public function getCurrentAuthPreference(Request $request)
    {
        $token = $request->user()->currentAccessToken();
        $device = Device::where('personal_access_tokens_id', $token->id)->firstOrFail();

        $this->authorize('canSeePreference', $device);

        return PreferenceResource::make($device->preference);
    }

    public function updateDevice(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string|max:255',
            'theme' => 'nullable|string|max:255',
            'language' => 'nullable|string|max:255',
            'text_scaler' => 'nullable|numeric',
            'notifications_are_enabled' => 'nullable|boolean',
        ]);

        $device = Device::where('identifier', $request->input('identifier'))->firstOrFail();

        $this->authorize('canSeePreference', $device);

        $device->preference->update($request->only([
            'theme',
            'language',
            'text_scaler',
            'notifications_are_enabled',
        ]));

        return PreferenceResource::make($device->preference);
    }

    public function updateAuth(Request $request)
    {
        $request->validate([
            'theme' => 'nullable|string|max:255',
            'language' => 'nullable|string|max:255',
            'text_scaler' => 'nullable|numeric',
            'notifications_are_enabled' => 'nullable|boolean',
        ]);

        $token = $request->user()->currentAccessToken();
        $device = Device::where('personal_access_tokens_id', $token->id)->firstOrFail();

        $this->authorize('canSeePreference', $device);

        $device->preference->update($request->only([
            'theme',
            'language',
            'text_scaler',
            'notifications_are_enabled',
        ]));

        return PreferenceResource::make($device->preference);
    }
}
