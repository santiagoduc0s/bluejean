<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Company extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'logo',
        'website',
        'address',
        'phone',
        'email',
    ];

    protected function casts(): array
    {
        return [
            //
        ];
    }

    public function users()
    {
        return $this->belongsToMany(User::class)
            ->withPivot('roles')
            ->withTimestamps();
    }

    public function channels()
    {
        return $this->hasMany(Channel::class);
    }
}
