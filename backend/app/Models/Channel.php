<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Channel extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'company_id',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'status' => 'string',
        ];
    }

    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    public function users()
    {
        return $this->belongsToMany(User::class)
            ->withTimestamps();
    }

    public function listeners()
    {
        return $this->hasMany(Listener::class);
    }

    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    public function scopeInactive($query)
    {
        return $query->where('status', 'inactive');
    }
}
