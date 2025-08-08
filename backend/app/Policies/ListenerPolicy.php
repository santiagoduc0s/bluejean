<?php

namespace App\Policies;

use App\Models\Listener;
use App\Models\User;

class ListenerPolicy
{
    /**
     * Check if user belongs to the same company as the listener's channel.
     */
    public function belongsToListenerCompany(User $user, Listener $listener): bool
    {
        return $user->companies()
            ->where('companies.id', $listener->channel->company_id)
            ->exists();
    }
}
