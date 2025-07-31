<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Mail;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Artisan::command('send-test-email', function () {
    $email = $this->ask('Enter email address');
    
    Mail::raw('This is a test email from your Laravel application.', function ($message) use ($email) {
        $message->to($email)
                ->subject('Test Email');
    });
    
    $this->info("Test email sent to {$email}");
})->purpose('Send a test email');
