<?php

namespace App\Policies;

use App\Models\Channel;
use App\Models\User;
use Illuminate\Auth\Access\Response;

class ChannelPolicy
{
    /**
     * Check if user belongs to the same company as the channel.
     */
    public function belongsToChannelCompany(User $user, Channel $channel): bool
    {
        return $user->companies()->where('companies.id', $channel->company_id)->exists();
    }
}
