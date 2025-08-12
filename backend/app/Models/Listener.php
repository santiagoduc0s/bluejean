<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Listener Model
 *
 * Represents people who want to receive notifications when drivers approach their location.
 * Each listener defines a geofence (location + threshold radius) for automatic notifications.
 * Used in the school bus tracking system to notify parents when buses are nearby.
 *
 * @property int $id
 * @property int $channel_id
 * @property string $name
 * @property string $phone_number
 * @property string|null $address
 * @property float|null $latitude
 * @property float|null $longitude
 * @property int $threshold_meters
 * @property string $status Status: 'active' or 'inactive' (default: 'active')
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 *
 * @property-read \App\Models\Channel $channel The channel this listener belongs to
 * @property-read \Illuminate\Database\Eloquent\Collection<\App\Models\ListenerNotification> $notifications Geofencing notifications sent to this listener
 */
class Listener extends Model
{
    use HasFactory;

    protected $fillable = [
        'channel_id',
        'name',
        'phone_number',
        'address',
        'latitude',
        'longitude',
        'threshold_meters',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'channel_id' => 'integer',
            'latitude' => 'decimal:8',
            'longitude' => 'decimal:8',
            'threshold_meters' => 'integer',
            'status' => 'string',
        ];
    }

    public function channel()
    {
        return $this->belongsTo(Channel::class);
    }

    public function notifications()
    {
        return $this->hasMany(ListenerNotification::class);
    }

    public function scopeSearch($query, $search)
    {
        return $query->when($search, function ($query, $search) {
            return $query->where(function ($query) use ($search) {
                $query->where('name', 'LIKE', "%{$search}%")
                      ->orWhere('phone_number', 'LIKE', "%{$search}%")
                      ->orWhere('address', 'LIKE', "%{$search}%")
                      ->orWhere('status', 'LIKE', "%{$search}%");
            });
        });
    }

    public function scopeByChannel($query, $channelId)
    {
        return $query->where('channel_id', $channelId);
    }

    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    public function scopeInactive($query)
    {
        return $query->where('status', 'inactive');
    }

    /**
     * Check if enough time has passed since the last notification for this listener
     * 
     * @return bool True if a notification can be sent (1 hour cooldown)
     */
    public function canSendNotification(): bool
    {
        $lastNotification = $this->notifications()
            ->latest('created_at')
            ->first();

        if (!$lastNotification) {
            return true; // No previous notification, can send
        }

        // Check if 1 hour (3600 seconds) has passed since last notification
        return $lastNotification->created_at->diffInSeconds(now()) >= 3600;
    }
}
