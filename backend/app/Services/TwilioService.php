<?php

namespace App\Services;

use Twilio\Rest\Client;
use Twilio\Exceptions\TwilioException;

/**
 * Twilio Service
 *
 * Handles Twilio integrations including WhatsApp messages, SMS, and voice calls
 * Used for sending geofencing notifications to listeners
 */
class TwilioService
{
    private Client $twilio;
    private string $fromNumber;

    /**
     * Create a new service instance
     */
    public function __construct()
    {
        $accountSid = config('services.twilio.account_sid');
        $authToken = config('services.twilio.auth_token');
        $this->fromNumber = config('services.twilio.whatsapp_from');

        if (!$accountSid || !$authToken || !$this->fromNumber) {
            throw new \InvalidArgumentException('Twilio credentials not configured properly');
        }

        $this->twilio = new Client($accountSid, $authToken);
    }

    /**
     * Send a WhatsApp message
     *
     * @param string $to Phone number in international format (e.g., +59899123456)
     * @param string $message Message content
     * @return array Result with success status and message details
     */
    public function sendWhatsApp(string $to, string $message): array
    {
        try {
            $twilioMessage = $this->twilio->messages->create(
                to: 'whatsapp:'.$to,
                options: [
                    'from' => $this->fromNumber,
                    'body' => $message
                ]
            );

            return [
                'success' => true,
                'sid' => $twilioMessage->sid,
                'status' => $twilioMessage->status,
                'to' => $to,
                'message' => 'WhatsApp message sent successfully'
            ];

        } catch (TwilioException $e) {
            \Log::error('Twilio WhatsApp error', [
                'to' => $to,
                'message' => $message,
                'error' => $e->getMessage(),
                'code' => $e->getCode()
            ]);

            return [
                'success' => false,
                'error' => $e->getMessage(),
                'code' => $e->getCode(),
                'to' => $to
            ];
        }
    }

    /**
     * Get Twilio account information for debugging
     *
     * @return array Account details
     */
    public function getAccountInfo(): array
    {
        try {
            $account = $this->twilio->api->v2010
                ->accounts(config('services.twilio.account_sid'))
                ->fetch();

            return [
                'sid' => $account->sid,
                'friendly_name' => $account->friendlyName,
                'status' => $account->status,
                'type' => $account->type
            ];
        } catch (TwilioException $e) {
            return [
                'error' => $e->getMessage()
            ];
        }
    }
}
