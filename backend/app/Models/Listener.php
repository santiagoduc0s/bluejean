<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

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
    ];

    protected function casts(): array
    {
        return [
            'channel_id' => 'integer',
            'latitude' => 'decimal:8',
            'longitude' => 'decimal:8',
        ];
    }

    public function channel()
    {
        return $this->belongsTo(Channel::class);
    }

    public function scopeSearch($query, $search)
    {
        return $query->when($search, function ($query, $search) {
            return $query->where(function ($query) use ($search) {
                $query->where('name', 'LIKE', "%{$search}%")
                      ->orWhere('phone_number', 'LIKE', "%{$search}%")
                      ->orWhere('address', 'LIKE', "%{$search}%");
            });
        });
    }

    public function scopeByChannel($query, $channelId)
    {
        return $query->where('channel_id', $channelId);
    }
}