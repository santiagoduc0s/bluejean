<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Log extends Model
{
    protected $fillable = [
        'message',
        'type',
        'stack_trace',
        'metadata',
        'environment',
    ];

    protected $casts = [
        'metadata' => 'array',
    ];

    // Log types constants
    public const TYPE_INFO = 'info';
    public const TYPE_WARNING = 'warning';
    public const TYPE_ERROR = 'error';
    public const TYPE_DEBUG = 'debug';
    public const TYPE_CRITICAL = 'critical';

    /**
     * Create a new log entry
     */
    public static function createLog(
        string $message,
        string $type = self::TYPE_INFO,
        ?string $stackTrace = null,
        ?array $metadata = null,
        ?string $environment = null
    ): self {
        return self::create([
            'message' => $message,
            'type' => $type,
            'stack_trace' => $stackTrace,
            'metadata' => $metadata,
            'environment' => $environment,
        ]);
    }

    /**
     * Log an info message
     */
    public static function info(string $message, ?string $stackTrace = null, ?array $metadata = null, ?string $environment = null): self
    {
        return self::createLog($message, self::TYPE_INFO, $stackTrace, $metadata, $environment);
    }

    /**
     * Log a warning message
     */
    public static function warning(string $message, ?string $stackTrace = null, ?array $metadata = null, ?string $environment = null): self
    {
        return self::createLog($message, self::TYPE_WARNING, $stackTrace, $metadata, $environment);
    }

    /**
     * Log an error message
     */
    public static function error(string $message, ?string $stackTrace = null, ?array $metadata = null, ?string $environment = null): self
    {
        return self::createLog($message, self::TYPE_ERROR, $stackTrace, $metadata, $environment);
    }

    /**
     * Log a debug message
     */
    public static function debug(string $message, ?string $stackTrace = null, ?array $metadata = null, ?string $environment = null): self
    {
        return self::createLog($message, self::TYPE_DEBUG, $stackTrace, $metadata, $environment);
    }

    /**
     * Log a critical message
     */
    public static function critical(string $message, ?string $stackTrace = null, ?array $metadata = null, ?string $environment = null): self
    {
        return self::createLog($message, self::TYPE_CRITICAL, $stackTrace, $metadata, $environment);
    }

    /**
     * Scope to filter by log type
     */
    public function scopeOfType($query, string $type)
    {
        return $query->where('type', $type);
    }

    /**
     * Scope to get recent logs
     */
    public function scopeRecent($query, int $days = 7)
    {
        return $query->where('created_at', '>=', now()->subDays($days));
    }
}