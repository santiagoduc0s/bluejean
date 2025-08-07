<?php

namespace App\Policies;

use App\Models\Company;
use App\Models\User;
use Illuminate\Auth\Access\Response;

class CompanyPolicy
{
    /**
     * Check if user belongs to the company.
     */
    public function belongsToCompany(User $user, Company $company): bool
    {
        return $user->companies()->where('companies.id', $company->id)->exists();
    }
}
