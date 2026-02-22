<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\Rule;

class LogController extends Controller
{
    public function store(Request $request): Response
    {
        $validated = $request->validate([
            'message' => 'required|string|max:10000',
            'type' => ['required', 'string', Rule::in([
                'info', 'warning', 'error', 'debug', 'critical',
            ])],
            'stack_trace' => 'nullable|string|max:10000',
            'metadata' => 'nullable|array',
        ]);

        $context = array_filter([
            'stack_trace' => $validated['stack_trace'] ?? null,
            'metadata' => $validated['metadata'] ?? null,
            'source' => 'app',
        ]);

        Log::{$validated['type']}($validated['message'], $context);

        return response([
            'message' => 'Log created successfully',
        ], 201);
    }
}
