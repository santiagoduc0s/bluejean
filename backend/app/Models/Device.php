<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property int|null $user_id
 * @property int|null $personal_access_tokens_id
 * @property int $preference_id
 * @property string $identifier
 * @property string|null $fcm_token
 * @property string $model
 * @property \App\Models\User|null $user
 * @property \App\Models\Preference $preference
 * @property \Laravel\Sanctum\PersonalAccessToken|null $accessToken
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 */
class Device extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'identifier',
        'model',
        'fcm_token',
        'personal_access_tokens_id',
        'preference_id',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function preference()
    {
        return $this->belongsTo(Preference::class);
    }

    public function accessToken()
    {
        return $this->belongsTo(\Laravel\Sanctum\PersonalAccessToken::class, 'personal_access_tokens_id');
    }
}
