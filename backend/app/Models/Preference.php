<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property Device|null $device
 * @property string|null $theme
 * @property string|null $language
 * @property int|null $text_scaler
 * @property bool $notifications_are_enabled
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 */
class Preference extends Model
{
    use HasFactory;

    protected $fillable = [
        'theme',
        'language',
        'text_scaler',
        'notifications_are_enabled',
    ];

    protected function casts(): array
    {
        return [
            'notifications_are_enabled' => 'boolean',
            'text_scaler' => 'float',
        ];
    }

    public function device()
    {
        return $this->hasOne(Device::class);
    }

}
