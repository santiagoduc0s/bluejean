<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\ChannelResource;
use App\Models\Channel;
use App\Models\Company;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Http\Request;

class ChannelController extends Controller
{
    use AuthorizesRequests;
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $request->validate([
            'per_page' => 'integer|min:1|max:100',
            'company_id' => 'integer|exists:companies,id',
        ]);

        $userCompanyIds = $request->user()->companies()->pluck('companies.id');

        $channels = Channel::whereIn('company_id', $userCompanyIds)
            ->when(
                $request->company_id,
                fn($query, $companyId) => $query->where('company_id', $companyId)
            )
            ->paginate($request->get('per_page', 15));

        return ChannelResource::collection($channels);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string|max:65535',
        ]);

        $company = auth()->user()->companies()->firstOrFail();

        $channel = Channel::create([
            'name' => $request->name,
            'description' => $request->description,
            'company_id' => $company->id,
        ]);

        return ChannelResource::make($channel);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $channel = Channel::findOrFail($id);
        $this->authorize('belongsToChannelCompany', $channel);

        return ChannelResource::make($channel);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'description' => 'sometimes|nullable|string|max:65535',
        ]);

        $channel = Channel::findOrFail($id);
        $this->authorize('belongsToChannelCompany', $channel);

        $channel->update($request->only(['name', 'description']));

        return ChannelResource::make($channel);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $channel = Channel::findOrFail($id);
        $this->authorize('belongsToChannelCompany', $channel);

        $channel->delete();

        return response()->noContent();
    }
}
