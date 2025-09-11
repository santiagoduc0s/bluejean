<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ListenerNotification extends Model
{
    use HasFactory;

    protected $fillable = [
        'listener_id',
        'driver_position_id',
        'type',
        'title',
        'body',
    ];

    protected function casts(): array
    {
        return [
            'listener_id' => 'integer',
            'created_at' => 'datetime',
            'updated_at' => 'datetime',
        ];
    }

    public function listener(): BelongsTo
    {
        return $this->belongsTo(Listener::class);
    }

}
