<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use App\Models\UserAdmin;
use Illuminate\Console\Command;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');



Artisan::command('user-admin:create {email} {password}', function () {
    UserAdmin::create([
        'email' => $this->argument('email'),
        'password' => $this->argument('password'),
    ]);

    $this->info('Admin created.');
})->purpose('Create a new admin user');
