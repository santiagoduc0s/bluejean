<?php

namespace App\Console\Commands;

use App\Services\TwilioService;
use Illuminate\Console\Command;

class SendWhatsAppCommand extends Command
{
    /**
     * The name and signature of the console command.
     */
    protected $signature = 'whatsapp:send';

    /**
     * The console command description.
     */
    protected $description = 'Send a WhatsApp message using Twilio service';

    /**
     * Execute the console command.
     */
    public function handle(TwilioService $twilioService): int
    {
        $this->info("Sending WhatsApp message to +59898100448...");

        try {
            $result = $twilioService->sendWhatsApp(
                to: "+59898100448",
                message: "Test message from the bus tracking system",
            );

            dump($result);
        } catch (\Exception $e) {
            dump($result);
            return Command::FAILURE;
        }

        return Command::SUCCESS;
    }
}
