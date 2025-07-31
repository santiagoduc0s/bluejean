<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SupportTicket extends Model
{
    protected $fillable = [
        'email',
        'title',
        'description',
        'files',
    ];

    protected $casts = [
        'files' => 'array',
    ];

    /**
     * Get the files attribute as an array
     */
    public function getFilesAttribute($value)
    {
        if (is_null($value)) {
            return [];
        }
        
        if (is_string($value)) {
            return json_decode($value, true) ?? [];
        }
        
        return is_array($value) ? $value : [];
    }

    /**
     * Get the count of files
     */
    public function getFilesCountAttribute(): int
    {
        return count($this->files);
    }
}
