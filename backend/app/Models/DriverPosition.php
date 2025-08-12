<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Driver Position Model
 *
 * Stores GPS coordinates of drivers for geofencing and tracking purposes.
 * Each position entry triggers automatic geofencing checks against active listeners.
 *
 * @property int $id
 * @property int $user_id
 * @property float $latitude
 * @property float $longitude
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 *
 * @property-read \App\Models\User $user The driver who reported this position
 */
class DriverPosition extends Model
{
    protected $fillable = [
        'user_id',
        'latitude',
        'longitude',
    ];

    protected $casts = [
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
