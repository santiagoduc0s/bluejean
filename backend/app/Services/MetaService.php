<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

/**
 * Meta Service
 *
 * Handles Meta WhatsApp Business API integrations for sending WhatsApp messages
 * Used for sending geofencing notifications to listeners through Meta's platform
 */
class MetaService
{
    private string $accessToken;
    private string $phoneNumberId;
    private string $whatsappBusinessAccountId;

    /**
     * Create a new service instance
     */
    public function __construct()
    {
        $this->accessToken = config('services.meta.access_token');
        $this->phoneNumberId = config('services.meta.phone_number_id');
        $this->whatsappBusinessAccountId = config('services.meta.whatsapp_business_account_id');

        if (!$this->accessToken || !$this->phoneNumberId || !$this->whatsappBusinessAccountId) {
            throw new \InvalidArgumentException('Meta WhatsApp credentials not configured properly');
        }
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
            Log::info('Sending WhatsApp message via Meta', [
                'to' => $to,
                'message_length' => strlen($message),
                'phone_number_id' => $this->phoneNumberId
            ]);

            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $this->accessToken,
                'Content-Type' => 'application/json',
            ])->post("https://graph.facebook.com/v18.0/{$this->phoneNumberId}/messages", [
                        'messaging_product' => 'whatsapp',
                        'recipient_type' => 'individual',
                        'to' => ltrim($to, '+'),
                        'type' => 'text',
                        'text' => [
                            'preview_url' => false,
                            'body' => $message
                        ]
                    ]);

            if ($response->successful()) {
                $data = $response->json();

                \App\Models\Log::createLog(
                    message: 'WhatsApp message sent successfully via Meta',
                    type: \App\Models\Log::TYPE_INFO,
                    metadata: $data,
                );

                return [
                    'success' => true,
                    'to' => $to,
                    'message' => $message,
                    ...$data,
                ];
            } else {
                $body = $response->body();
                $errorData = $response->json();

                \App\Models\Log::createLog(
                    message: "Failed to send WhatsApp message via Meta: $body",
                    type: \App\Models\Log::TYPE_ERROR,
                );

                return [
                    'success' => false,
                    'error' => $errorData['error']['message'] ?? 'Unknown error',
                    'code' => $errorData['error']['code'] ?? $response->status(),
                    'to' => $to
                ];
            }

        } catch (\Exception $e) {
            \App\Models\Log::createLog(
                message: 'Exception while sending WhatsApp message via Meta',
                type: \App\Models\Log::TYPE_ERROR,
                metadata: [
                    'to' => $to,
                    'exception_message' => $e->getMessage(),
                    'exception_code' => $e->getCode(),
                    'message_body' => $message
                ],
            );

            return [
                'success' => false,
                'error' => $e->getMessage(),
                'code' => $e->getCode(),
                'to' => $to
            ];
        }
    }

    /**
     * Get WhatsApp Business Account information for debugging
     *
     * @return array Account details
     */
    public function getAccountInfo(): array
    {
        try {
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $this->accessToken,
            ])->get("https://graph.facebook.com/v18.0/{$this->whatsappBusinessAccountId}", [
                        'fields' => 'id,name,currency,timezone_id,message_template_namespace'
                    ]);

            if ($response->successful()) {
                return $response->json();
            } else {
                $errorData = $response->json();
                return [
                    'error' => $errorData['error']['message'] ?? 'Unknown error',
                    'code' => $errorData['error']['code'] ?? $response->status()
                ];
            }
        } catch (\Exception $e) {
            return [
                'error' => $e->getMessage(),
                'code' => $e->getCode()
            ];
        }
    }

    /**
     * Get phone number information for debugging
     *
     * @return array Phone number details
     */
    public function getPhoneNumberInfo(): array
    {
        try {
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $this->accessToken,
            ])->get("https://graph.facebook.com/v18.0/{$this->phoneNumberId}", [
                        'fields' => 'id,display_phone_number,verified_name,quality_rating,status'
                    ]);

            if ($response->successful()) {
                return $response->json();
            } else {
                $errorData = $response->json();
                return [
                    'error' => $errorData['error']['message'] ?? 'Unknown error',
                    'code' => $errorData['error']['code'] ?? $response->status()
                ];
            }
        } catch (\Exception $e) {
            return [
                'error' => $e->getMessage(),
                'code' => $e->getCode()
            ];
        }
    }

    /**
     * Send a WhatsApp template message (for production)
     *
     * @param string $to Phone number in international format
     * @param string $templateName Template name
     * @param string $languageCode Language code (e.g., 'en_US')
     * @param array $parameters Template parameters if needed
     * @return array Result with success status and message details
     */
    public function sendTemplate(string $to, string $templateName, string $languageCode = 'en_US', array $parameters = []): array
    {
        try {
            Log::info('Sending WhatsApp template message via Meta', [
                'to' => $to,
                'template' => $templateName,
                'language' => $languageCode,
                'parameters_count' => count($parameters),
                'phone_number_id' => $this->phoneNumberId
            ]);

            $payload = [
                'messaging_product' => 'whatsapp',
                'recipient_type' => 'individual',
                'to' => ltrim($to, '+'),
                'type' => 'template',
                'template' => [
                    'name' => $templateName,
                    'language' => ['code' => $languageCode]
                ]
            ];

            // Add parameters if provided
            if (!empty($parameters)) {
                $payload['template']['components'] = [
                    [
                        'type' => 'body',
                        'parameters' => array_map(function($param) {
                            return ['type' => 'text', 'text' => $param];
                        }, $parameters)
                    ]
                ];
            }

            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $this->accessToken,
                'Content-Type' => 'application/json',
            ])->post("https://graph.facebook.com/v18.0/{$this->phoneNumberId}/messages", $payload);

            if ($response->successful()) {
                $data = $response->json();

                \App\Models\Log::createLog(
                    message: 'WhatsApp template message sent successfully via Meta',
                    type: \App\Models\Log::TYPE_INFO,
                    metadata: [
                        'to' => $to,
                        'template' => $templateName,
                        'parameters' => $parameters,
                        'response' => $data
                    ],
                );

                return [
                    'success' => true,
                    'to' => $to,
                    'template' => $templateName,
                    'parameters' => $parameters,
                    ...$data,
                ];
            } else {
                $body = $response->body();
                $errorData = $response->json();

                \App\Models\Log::createLog(
                    message: "Failed to send WhatsApp template message via Meta: $body",
                    type: \App\Models\Log::TYPE_ERROR,
                    metadata: [
                        'to' => $to,
                        'template' => $templateName,
                        'parameters' => $parameters,
                        'error_response' => $errorData
                    ],
                );

                return [
                    'success' => false,
                    'error' => $errorData['error']['message'] ?? 'Unknown error',
                    'code' => $errorData['error']['code'] ?? $response->status(),
                    'to' => $to,
                    'template' => $templateName
                ];
            }

        } catch (\Exception $e) {
            \App\Models\Log::createLog(
                message: 'Exception while sending WhatsApp template message via Meta',
                type: \App\Models\Log::TYPE_ERROR,
                metadata: [
                    'to' => $to,
                    'template' => $templateName,
                    'parameters' => $parameters,
                    'exception_message' => $e->getMessage(),
                    'exception_code' => $e->getCode(),
                ],
            );

            return [
                'success' => false,
                'error' => $e->getMessage(),
                'code' => $e->getCode(),
                'to' => $to,
                'template' => $templateName
            ];
        }
    }
}
