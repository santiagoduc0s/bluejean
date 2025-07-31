<?php

namespace App\Policies;

use App\Models\Device;
use App\Models\User;
use Illuminate\Auth\Access\Response;

class DevicePolicy
{
    /**
     * Determine whether the user is the owner of the device.
     */
    public function isTheOwner(User $user, Device $device): bool
    {

        return $device->user_id === $user->id;
    }

    /**
     * Determine whether the user can access the device's preference.
     * If the device has a user_id, only that user can access the preference.
     * If the device has no user_id, anyone can access it.
     */
    public function canSeePreference(?User $user, Device $device): bool
    {
        // If device has no user_id, it's public access
        if (!$device->user_id) {
            return true;
        }

        // If device has user_id but no authenticated user, deny access
        if (!$user) {
            return false;
        }

        // If device has user_id, only that user can access
        return $this->isTheOwner($user, $device);
    }
}
