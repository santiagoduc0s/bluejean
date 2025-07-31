<?php

namespace App\Filament\Resources\FirebaseNotificationResource\Pages;

use App\Filament\Resources\FirebaseNotificationResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListFirebaseNotifications extends ListRecords
{
    protected static string $resource = FirebaseNotificationResource::class;

    protected function getHeaderActions(): array
    {
        return [
            // No create action since this is read-only
        ];
    }
}