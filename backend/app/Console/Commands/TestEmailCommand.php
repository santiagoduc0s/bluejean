<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Mail;
use App\Mail\TestMail;

class TestEmailCommand extends Command
{
    protected $signature = 'mail:test {email}';
    protected $description = 'Send a test email to verify mail service is working';

    public function handle(): int
    {
        $email = $this->argument('email');
        
        $this->info("📧 Testing email service...");
        $this->line("To: {$email}");
        $this->line("Service: " . config('mail.mailer'));
        $this->line("From: " . config('mail.from.address'));
        $this->newLine();

        try {
            Mail::raw(
                "🚌 Bus Escolares - Email Test\n\n" .
                "✅ Email service is working correctly!\n\n" .
                "Service: " . config('mail.mailer') . "\n" .
                "From: " . config('mail.from.address') . "\n" .
                "Sent at: " . now()->format('Y-m-d H:i:s') . "\n\n" .
                "This is a test email to verify the mail configuration.",
                function ($message) use ($email) {
                    $message->to($email)
                           ->subject('🚌 Bus Escolares - Email Service Test')
                           ->from(config('mail.from.address'), config('mail.from.name'));
                }
            );

            $this->info("✅ Test email sent successfully!");
            $this->line("📬 Check your inbox at: {$email}");
            
        } catch (\Exception $e) {
            $this->error("❌ Failed to send test email:");
            $this->line("Error: " . $e->getMessage());
            
            // Show configuration for debugging
            $this->newLine();
            $this->warn("📋 Current mail configuration:");
            $this->line("Mailer: " . config('mail.mailer'));
            $this->line("From Address: " . config('mail.from.address'));
            $this->line("From Name: " . config('mail.from.name'));
            
            if (config('mail.mailer') === 'resend') {
                $this->line("Resend API Key: " . (config('services.resend.key') ? '✅ Set' : '❌ Missing'));
            }
            
            return Command::FAILURE;
        }

        return Command::SUCCESS;
    }
}