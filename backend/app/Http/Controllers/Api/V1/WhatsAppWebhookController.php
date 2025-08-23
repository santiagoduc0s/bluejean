<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response as HttpResponse;

class WhatsAppWebhookController extends Controller
{
    public function verify(Request $request)
    {
        Log::info('WhatsApp webhook verification attempt', [
            'url' => $request->fullUrl(),
            'method' => $request->method(),
            'headers' => $request->headers->all(),
            'query_params' => $request->query(),
            'all_params' => $request->all(),
        ]);

        $mode = $request->query('hub_mode');
        $challenge = $request->query('hub_challenge');
        $token = $request->query('hub_verify_token');
        $myToken = config('services.whatsapp.verify_token');

        Log::info('WhatsApp verification details', [
            'hub_mode' => $mode,
            'hub_challenge' => $challenge,
            'hub_verify_token' => $token,
            'expected_token' => $myToken,
            'mode_match' => $mode === 'subscribe',
            'token_match' => $token === $myToken,
        ]);

        if ($mode && $token) {
            if ($mode === 'subscribe' && $token === $myToken) {
                Log::info('WhatsApp webhook verified successfully', [
                    'challenge' => $challenge
                ]);
                
                // Return 204 No Content as per WhatsApp documentation
                return response()->noContent();
            } else {
                Log::warning('WhatsApp webhook verification failed', [
                    'reason' => 'Mode or token mismatch',
                    'mode' => $mode,
                    'token_provided' => $token ? 'yes' : 'no',
                    'expected_mode' => 'subscribe',
                    'expected_token' => $myToken
                ]);
                return response('', HttpResponse::HTTP_FORBIDDEN);
            }
        }

        Log::warning('WhatsApp webhook verification failed', [
            'reason' => 'Missing mode or token',
            'mode' => $mode,
            'token' => $token ? 'provided' : 'missing'
        ]);
        return response('', HttpResponse::HTTP_FORBIDDEN);
    }

    public function webhook(Request $request)
    {
        $bodyParam = $request->all();

        Log::info('WhatsApp webhook received', $bodyParam);

        if (isset($bodyParam['object'])) {
            Log::info('Inside body param');

            if (isset($bodyParam['entry']) &&
                isset($bodyParam['entry'][0]['changes']) &&
                isset($bodyParam['entry'][0]['changes'][0]['value']['messages']) &&
                isset($bodyParam['entry'][0]['changes'][0]['value']['messages'][0])) {

                $phoneNoId = $bodyParam['entry'][0]['changes'][0]['value']['metadata']['phone_number_id'];
                $from = $bodyParam['entry'][0]['changes'][0]['value']['messages'][0]['from'];
                $message = $bodyParam['entry'][0]['changes'][0]['value']['messages'][0];
                $messageType = $message['type'] ?? 'unknown';

                Log::info("Phone number: {$phoneNoId}");
                Log::info("From: {$from}");
                Log::info("Message type: {$messageType}");

                if ($messageType === 'button') {
                    // User clicked a template button
                    $buttonText = $message['button']['text'] ?? '';
                    $buttonPayload = $message['button']['payload'] ?? '';
                    
                    Log::info("Button clicked!", [
                        'button_text' => $buttonText,
                        'button_payload' => $buttonPayload,
                        'from' => $from
                    ]);
                    
                    $this->handleButtonClick($phoneNoId, $from, $buttonText, $buttonPayload);
                    
                } elseif ($messageType === 'text') {
                    // Regular text message
                    $msgBody = $message['text']['body'] ?? '';
                    Log::info("Text message: {$msgBody}");
                    $this->sendReply($phoneNoId, $from, $msgBody);
                }

                return response('', HttpResponse::HTTP_OK);
            } else {
                return response('', HttpResponse::HTTP_NOT_FOUND);
            }
        }

        return response('', HttpResponse::HTTP_OK);
    }

    private function sendReply(string $phoneNoId, string $from, string $msgBody): void
    {
        $token = config('services.meta.access_token');

        $response = Http::withHeaders([
            'Content-Type' => 'application/json',
        ])->post("https://graph.facebook.com/v13.0/{$phoneNoId}/messages?access_token={$token}", [
            'messaging_product' => 'whatsapp',
            'to' => $from,
            'text' => [
                'body' => "Hi! I received your message: {$msgBody}"
            ]
        ]);

        if ($response->successful()) {
            Log::info('WhatsApp reply sent successfully');
        } else {
            Log::error('Failed to send WhatsApp reply', [
                'status' => $response->status(),
                'body' => $response->body()
            ]);
        }
    }

    private function handleButtonClick(string $phoneNoId, string $from, string $buttonText, string $buttonPayload): void
    {
        Log::info("Processing button click", [
            'payload' => $buttonPayload,
            'text' => $buttonText,
            'from' => $from
        ]);

        // Handle different button payloads
        switch ($buttonPayload) {
            case 'confirm_booking':
                $replyMessage = "Thank you for confirming your booking! We'll send you details shortly.";
                break;
            case 'cancel_booking':
                $replyMessage = "Your booking has been cancelled. No worries, you can book again anytime!";
                break;
            case 'get_info':
                $replyMessage = "Here's more information about our services...";
                break;
            default:
                $replyMessage = "Thank you for clicking '{$buttonText}'. How can I help you?";
        }

        $this->sendReply($phoneNoId, $from, $replyMessage);
    }
}
