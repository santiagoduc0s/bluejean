<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\PreferenceResource;
use App\Models\Preference;
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

        $preference = Preference::findOrFail($device->preference_id);

        return PreferenceResource::make($preference);
    }

    public function getCurrentAuthPreference(Request $request)
    {
        $preference = Preference::findOrFail($request->user()->preference_id);

        $this->authorize('canGetPreference', $preference);

        return PreferenceResource::make($preference);
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
        $preference = Preference::findOrFail($device->preference_id);

        $this->authorize('canGetPreference', $preference);

        $preference->update($request->only([
            'theme',
            'language',
            'text_scaler',
            'notifications_are_enabled',
        ]));

        return PreferenceResource::make($preference);
    }

    public function updateAuth(Request $request)
    {
        $request->validate([
            'theme' => 'nullable|string|max:255',
            'language' => 'nullable|string|max:255',
            'text_scaler' => 'nullable|numeric',
            'notifications_are_enabled' => 'nullable|boolean',
        ]);

        $preference = Preference::findOrFail($request->user()->preference_id);

        $this->authorize('canGetPreference', $preference);

        $preference->update($request->only([
            'theme',
            'language',
            'text_scaler',
            'notifications_are_enabled',
        ]));

        return PreferenceResource::make($preference);
    }
}
