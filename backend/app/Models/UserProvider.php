<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Hash;

/**
 * @property int $id
 * @property int $user_id
 * @property string $provider
 * @property string $provider_id
 * @property string|null $provider_email
 * @property string|null $password
 * @property \Carbon\Carbon|null $email_verified_at
 * @property array|null $provider_data
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 */
class UserProvider extends Model
{
    protected $fillable = [
        'user_id',
        'provider',
        'provider_id',
        'provider_email',
        'password',
        'email_verified_at',
        'provider_data',
    ];

    protected $hidden = [
        'password',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'provider_data' => 'array',
            'password' => 'hashed',
        ];
    }

    /**
     * Get the user that owns this provider.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Scope to find provider by type and ID.
     */
    public function scopeByProvider($query, string $provider, string $providerId)
    {
        return $query->where('provider', $provider)
                    ->where('provider_id', $providerId);
    }

    /**
     * Scope to find email provider by email.
     */
    public function scopeByEmail($query, string $email)
    {
        return $query->where('provider', 'email')
                    ->where('provider_id', $email);
    }

    /**
     * Check if this provider's email is verified.
     */
    public function hasVerifiedEmail(): bool
    {
        return $this->email_verified_at !== null;
    }

    /**
     * Mark the provider's email as verified.
     */
    public function markEmailAsVerified(): bool
    {
        return $this->update(['email_verified_at' => now()]);
    }

    /**
     * Check password for email provider.
     */
    public function checkPassword(string $password): bool
    {
        if ($this->provider !== 'email' || !$this->password) {
            return false;
        }

        return Hash::check($password, $this->password);
    }

    /**
     * Get email for verification (for email providers).
     */
    public function getEmailForVerification(): string
    {
        return $this->provider_email ?? $this->provider_id;
    }

    /**
     * Create or update a provider for a user.
     */
    public static function createOrUpdateProvider(
        int $userId,
        string $provider,
        string $providerId,
        ?string $providerEmail = null,
        ?string $password = null,
        ?array $providerData = null
    ): self {
        return self::updateOrCreate(
            [
                'provider' => $provider,
                'provider_id' => $providerId,
            ],
            [
                'user_id' => $userId,
                'provider_email' => $providerEmail,
                'password' => $password,
                'provider_data' => $providerData,
            ]
        );
    }
}
