<?php

namespace App\Policies;

use App\Models\Preference;
use App\Models\User;

class PreferencePolicy
{
    /**
     * Determine whether the user can view the preference.
     * If the preference has a user (through a linked device), 
     * only that user can access it.
     */
    public function canGetPreference(?User $user, Preference $preference): bool
    {
        // Get the user associated with this preference (if any)
        $preferenceUser = $preference->user;
        
        // If preference has no associated user, it's public access
        if (!$preferenceUser) {
            return true;
        }
        
        // If preference has an associated user but no authenticated user, deny access
        if (!$user) {
            return false;
        }
        
        // If preference has an associated user, only that user can access
        return $preferenceUser->id === $user->id;
    }
}