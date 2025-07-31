<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\SupportTicketResource;
use App\Models\SupportTicket;
use Illuminate\Http\Request;

class SupportTicketController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'email' => 'required|email|max:255',
            'title' => 'required|string|max:255',
            'description' => 'required|string|max:5000',
            'files' => 'nullable|array|max:5',
            'files.*' => 'string|max:255',
        ]);

        $supportTicket = SupportTicket::create([
            'email' => $request->input('email'),
            'title' => $request->input('title'),
            'description' => $request->input('description'),
            'files' => $request->input('files', []),
        ]);

        return SupportTicketResource::make($supportTicket);
    }
}
