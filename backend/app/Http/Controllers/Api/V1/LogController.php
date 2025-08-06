<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Log;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Validation\Rule;

class LogController extends Controller
{
    /**
     * Store a new log entry from the app
     */
    public function store(Request $request): Response
    {
        $validated = $request->validate([
            'message' => 'required|string|max:10000',
            'type' => ['required', 'string', Rule::in([
                Log::TYPE_INFO,
                Log::TYPE_WARNING,
                Log::TYPE_ERROR,
                Log::TYPE_DEBUG,
                Log::TYPE_CRITICAL,
            ])],
            'stack_trace' => 'nullable|string|max:10000',
            'metadata' => 'nullable|array',
            'environment' => 'nullable|string|max:50',
        ]);

        $log = Log::createLog(
            message: $validated['message'],
            type: $validated['type'],
            stackTrace: $validated['stack_trace'] ?? null,
            metadata: $validated['metadata'] ?? null,
            environment: $validated['environment'] ?? null
        );

        return response([
            'message' => 'Log created successfully',
            'data' => [
                'id' => $log->id,
                'created_at' => $log->created_at,
            ]
        ], 201);
    }
}
