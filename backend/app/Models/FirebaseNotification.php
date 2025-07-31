<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

/**
 * @property int $id
 * @property string $batch_id
 * @property int|null $user_id
 * @property int|null $device_id
 * @property string|null $fcm_token
 * @property string $title
 * @property string $body
 * @property array|null $data
 * @property string $status
 * @property string|null $firebase_message_id
 * @property string|null $error_message
 * @property \Carbon\Carbon|null $sent_at
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 * @property \App\Models\User|null $user
 * @property \App\Models\Device|null $device
 */
class FirebaseNotification extends Model
{
    use HasFactory;

    protected $fillable = [
        'batch_id',
        'user_id',
        'device_id',
        'fcm_token',
        'title',
        'body',
        'data',
        'status',
        'firebase_message_id',
        'error_message',
        'sent_at',
    ];

    protected $casts = [
        'data' => 'array',
        'sent_at' => 'datetime',
    ];

    /**
     * Relationships
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function device()
    {
        return $this->belongsTo(Device::class);
    }

    /**
     * Scopes
     */
    public function scopeByBatch($query, string $batchId)
    {
        return $query->where('batch_id', $batchId);
    }

    public function scopeByStatus($query, string $status)
    {
        return $query->where('status', $status);
    }


    public function scopeByUser($query, int $userId)
    {
        return $query->where('user_id', $userId);
    }

    public function scopeByDevice($query, int $deviceId)
    {
        return $query->where('device_id', $deviceId);
    }

    public function scopeRecent($query, int $days = 7)
    {
        return $query->where('created_at', '>=', now()->subDays($days));
    }

    public function scopeSuccessful($query)
    {
        return $query->where('status', 'success');
    }

    public function scopeFailed($query)
    {
        return $query->where('status', 'error');
    }

    public function scopePending($query)
    {
        return $query->where('status', 'pending');
    }

    /**
     * Static methods for batch analytics
     */
    public static function getBatchStats(string $batchId): array
    {
        $notifications = self::byBatch($batchId)->get();
        
        return [
            'total' => $notifications->count(),
            'successful' => $notifications->where('status', 'success')->count(),
            'failed' => $notifications->where('status', 'error')->count(),
            'pending' => $notifications->where('status', 'pending')->count(),
            'success_rate' => $notifications->count() > 0 
                ? round(($notifications->where('status', 'success')->count() / $notifications->count()) * 100, 2)
                : 0,
        ];
    }

    public static function getUserStatsInBatch(string $batchId, int $userId): array
    {
        $notifications = self::byBatch($batchId)->byUser($userId)->get();
        
        return [
            'total_devices' => $notifications->count(),
            'successful_devices' => $notifications->where('status', 'success')->count(),
            'failed_devices' => $notifications->where('status', 'error')->count(),
            'pending_devices' => $notifications->where('status', 'pending')->count(),
        ];
    }
}