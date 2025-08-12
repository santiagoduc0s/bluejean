<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\ListenerResource;
use App\Models\Channel;
use App\Models\Listener;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Http\Request;

class ListenerController extends Controller
{
    use AuthorizesRequests;

    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $request->validate([
            'per_page' => 'integer|min:1|max:100',
            'channel_id' => 'integer|exists:channels,id',
            'search' => 'string|max:255',
        ]);

        $userCompanyIds = $request->user()->companies()->pluck('companies.id');

        $listeners = Listener::whereHas('channel', function ($query) use ($userCompanyIds) {
            $query->whereIn('company_id', $userCompanyIds);
        })
            ->when(
                $request->channel_id,
                fn($query, $channelId) => $query->byChannel($channelId)
            )
            ->when(
                $request->search,
                fn($query, $search) => $query->search($search)
            )
            ->with('channel')
            ->paginate($request->get('per_page', 15));

        return ListenerResource::collection($listeners);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'channel_id' => 'required|integer|exists:channels,id',
            'name' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20',
            'address' => 'nullable|string|max:500',
            'latitude' => 'nullable|numeric|between:-90,90',
            'longitude' => 'nullable|numeric|between:-180,180',
            'threshold_meters' => 'nullable|integer|min:100|max:1000',
            'status' => 'nullable|string|in:active,inactive',
        ]);

        $channel = Channel::findOrFail($request->channel_id);
        $this->authorize('belongsToChannelCompany', $channel);

        $listener = Listener::create([
            'channel_id' => $request->channel_id,
            'name' => $request->name,
            'phone_number' => $request->phone_number,
            'address' => $request->address,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
            'threshold_meters' => $request->threshold_meters ?? 200,
            'status' => $request->status ?? 'active',
        ]);

        return ListenerResource::make($listener->load('channel'));
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $listener = Listener::with('channel')->findOrFail($id);
        $this->authorize('belongsToListenerCompany', $listener);

        return ListenerResource::make($listener);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'phone_number' => 'sometimes|required|string|max:20',
            'address' => 'nullable|string|max:500',
            'latitude' => 'nullable|numeric|between:-90,90',
            'longitude' => 'nullable|numeric|between:-180,180',
            'threshold_meters' => 'nullable|integer|min:100|max:1000',
            'status' => 'sometimes|string|in:active,inactive',
        ]);

        $listener = Listener::findOrFail($id);
        $this->authorize('belongsToListenerCompany', $listener);

        $listener->update($request->only(['name', 'phone_number', 'address', 'latitude', 'longitude', 'threshold_meters', 'status']));

        return ListenerResource::make($listener->load('channel'));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $listener = Listener::findOrFail($id);
        $this->authorize('belongsToListenerCompany', $listener);

        $listener->delete();

        return response()->noContent();
    }

    /**
     * Get listeners by channel with optional search.
     */
    public function getByChannel(Request $request, string $channelId)
    {
        $request->validate([
            'per_page' => 'integer|min:1|max:100',
            'search' => 'string|max:255',
        ]);

        $channel = Channel::findOrFail($channelId);
        $this->authorize('belongsToChannelCompany', $channel);

        $listeners = Listener::byChannel($channelId)
            ->when(
                $request->search,
                fn($query, $search) => $query->search($search)
            )
            ->with('channel')
            ->paginate($request->get('per_page', 15));

        return ListenerResource::collection($listeners);
    }
}
