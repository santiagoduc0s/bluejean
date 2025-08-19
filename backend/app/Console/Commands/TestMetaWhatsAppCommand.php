<?php

namespace App\Console\Commands;

use App\Services\MetaService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;

class TestMetaWhatsAppCommand extends Command
{
    /**
     * The name and signature of the console command.
     */
    protected $signature = 'meta:test-whatsapp {phone?} {--full : Run full comprehensive test} {--template= : Test specific template} {--lang=es : Template language}';

    /**
     * The console command description.
     */
    protected $description = 'Complete Meta WhatsApp service test with analytics, templates, and production diagnostics';

    /**
     * Execute the console command.
     */
    public function handle(MetaService $metaService): int
    {
        $this->info("🧪 Meta WhatsApp Complete Test Suite\n");

        // 1. Account Information
        $this->testAccountInfo($metaService);

        // 2. Phone Number Information
        $this->testPhoneInfo($metaService);

        // 3. Test Template Message (if specified) or Free-form Message
        $templateMessageId = null;
        $messageId = null;

        if ($this->option('template')) {
            $templateMessageId = $this->testTemplateMessage($metaService);
        } else {
            $messageId = $this->testSendMessage($metaService);
        }

        if ($this->option('full')) {
            // 4. Message Templates (Production diagnostics)
            $this->checkMessageTemplates();

            // 5. Business Verification (Production diagnostics)
            $this->checkBusinessVerification();

            // 6. Analytics & Insights
            $this->testAnalytics();

            // 7. Webhook Configuration
            $this->testWebhookConfig();

            // 8. Recent Logs Analysis
            $this->testRecentLogs();

            // 9. Configuration Summary
            $this->showConfigSummary();
        }

        $this->newLine();
        $finalMessageId = $templateMessageId ?? $messageId ?? 'N/A';
        $this->info("✅ Test completed! Message ID: " . $finalMessageId);

        if (!$this->option('full') && !$this->option('template')) {
            $this->line("💡 Options:");
            $this->line("   --full: Comprehensive testing and diagnostics");
            $this->line("   --template=name: Test specific template (e.g., driver_approaching)");
            $this->line("   --lang=code: Template language (default: es)");
        }

        return Command::SUCCESS;
    }

    private function testAccountInfo(MetaService $metaService): void
    {
        $this->info("📋 1. Account Information:");
        $accountInfo = $metaService->getAccountInfo();

        if (isset($accountInfo['error'])) {
            $this->error("❌ Account error: " . $accountInfo['error']);
        } else {
            $this->line("✅ Account: " . ($accountInfo['name'] ?? 'Unknown'));
            $this->line("   ID: " . ($accountInfo['id'] ?? 'Unknown'));
            $this->line("   Currency: " . ($accountInfo['currency'] ?? 'Unknown'));
            $this->line("   Namespace: " . ($accountInfo['message_template_namespace'] ?? 'Not set'));
        }
        $this->newLine();
    }

    private function testPhoneInfo(MetaService $metaService): void
    {
        $this->info("📱 2. Phone Number Status:");
        $phoneInfo = $metaService->getPhoneNumberInfo();

        if (isset($phoneInfo['error'])) {
            $this->error("❌ Phone error: " . $phoneInfo['error']);
        } else {
            $status = $phoneInfo['status'] ?? 'Unknown';
            $quality = $phoneInfo['quality_rating'] ?? 'Unknown';

            $statusIcon = $status === 'CONNECTED' ? '✅' : '❌';
            $qualityIcon = $quality === 'GREEN' ? '🟢' : ($quality === 'YELLOW' ? '🟡' : '🔴');

            $this->line("{$statusIcon} Status: {$status}");
            $this->line("{$qualityIcon} Quality: {$quality}");
            $this->line("📞 Number: " . ($phoneInfo['display_phone_number'] ?? 'Unknown'));
            $this->line("✔️ Verified: " . ($phoneInfo['verified_name'] ?? 'Unknown'));
        }
        $this->newLine();
    }

    private function testSendMessage(MetaService $metaService): ?string
    {
        $phone = $this->argument('phone') ?? '+59898100448';
        $this->info("📤 3. Sending Test Message to {$phone}:");

        try {
            $result = $metaService->sendWhatsApp(
                to: $phone,
                message: "🚌 Meta WhatsApp Test\n\n" .
                        "✅ Service is working correctly!\n" .
                        "🕐 Timestamp: " . now()->format('Y-m-d H:i:s') . "\n" .
                        "📱 From: Bus Escolares System"
            );

            if ($result['success']) {
                $messageId = $result['messages'][0]['id'] ?? null;
                $this->info("✅ Message sent successfully!");
                $this->line("📬 Message ID: " . ($messageId ?? 'N/A'));
                $this->line("📞 To: " . $result['to']);
                $this->line("👤 Contact ID: " . ($result['contacts'][0]['wa_id'] ?? 'N/A'));
                return $messageId;
            } else {
                $this->error("❌ Failed to send message:");
                $this->line("Error: " . $result['error']);
                $this->line("Code: " . $result['code']);
            }
        } catch (\Exception $e) {
            $this->error("💥 Exception: " . $e->getMessage());
        }

        $this->newLine();
        return null;
    }

    private function testAnalytics(): void
    {
        $this->info("📊 4. Analytics & Insights:");

        $accessToken = config('services.meta.access_token');
        $accountId = config('services.meta.whatsapp_business_account_id');

        try {
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $accessToken,
            ])->get("https://graph.facebook.com/v18.0/{$accountId}/insights", [
                'metric' => 'messages_sent,messages_delivered',
                'granularity' => 'daily',
                'since' => now()->subDays(1)->format('Y-m-d'),
                'until' => now()->format('Y-m-d')
            ]);

            if ($response->successful()) {
                $data = $response->json();
                $this->line("✅ Analytics available");
                $this->line(json_encode($data, JSON_PRETTY_PRINT));
            } else {
                $this->warn("⚠️  Analytics not available (requires business verification)");
            }
        } catch (\Exception $e) {
            $this->warn("⚠️  Analytics error: " . $e->getMessage());
        }

        $this->newLine();
    }

    private function testWebhookConfig(): void
    {
        $this->info("📡 5. Webhook Configuration:");

        $accessToken = config('services.meta.access_token');
        $accountId = config('services.meta.whatsapp_business_account_id');

        try {
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $accessToken,
            ])->get("https://graph.facebook.com/v18.0/{$accountId}/subscribed_apps");

            if ($response->successful()) {
                $data = $response->json();
                if (!empty($data['data'])) {
                    $this->line("✅ Webhooks configured:");
                    foreach ($data['data'] as $app) {
                        $this->line("   App: " . ($app['whatsapp_business_api_data']['name'] ?? 'Unknown'));
                        $this->line("   ID: " . ($app['whatsapp_business_api_data']['id'] ?? 'Unknown'));
                    }
                } else {
                    $this->warn("⚠️  No webhooks configured");
                }
            } else {
                $this->warn("⚠️  Cannot check webhook config");
            }
        } catch (\Exception $e) {
            $this->warn("⚠️  Webhook check error: " . $e->getMessage());
        }

        $this->newLine();
    }

    private function testRecentLogs(): void
    {
        $this->info("📝 6. Recent Meta Logs (Last 5):");

        try {
            $logs = \App\Models\Log::where('message', 'like', '%Meta%')
                ->orderBy('created_at', 'desc')
                ->limit(5)
                ->get(['message', 'type', 'created_at']);

            if ($logs->count() > 0) {
                foreach ($logs as $log) {
                    $icon = $log->type === 'info' ? '✅' : '❌';
                    $this->line("{$icon} " . $log->created_at->format('H:i:s') . " - " . $log->message);
                }
            } else {
                $this->line("No recent Meta logs found.");
            }
        } catch (\Exception $e) {
            $this->warn("⚠️  Cannot check logs: " . $e->getMessage());
        }

        $this->newLine();
    }

    private function showConfigSummary(): void
    {
        $this->info("⚙️ 7. Configuration Summary:");
        $this->line("Access Token: " . (config('services.meta.access_token') ? '✅ Set' : '❌ Missing'));
        $this->line("Phone Number ID: " . (config('services.meta.phone_number_id') ?: '❌ Missing'));
        $this->line("Account ID: " . (config('services.meta.whatsapp_business_account_id') ?: '❌ Missing'));

        $this->newLine();
        $this->info("💡 Troubleshooting Tips:");
        $this->line("• If messages aren't received, add recipient as test user in Meta Business Manager");
        $this->line("• For production, use approved message templates");
        $this->line("• GREEN quality rating and CONNECTED status are optimal");
        $this->line("• Message IDs confirm successful API acceptance");
    }

    private function testTemplateMessage(MetaService $metaService): ?string
    {
        $phone = $this->argument('phone') ?? '+59898100448';
        $template = $this->option('template');
        $language = $this->option('lang') ?? 'es';

        // Test with sample distance parameter for driver_approaching template
        $parameters = [];
        if ($template === 'driver_approaching') {
            $parameters = ['500m']; // Sample distance for testing
        }

        $this->info("📋 Template Message Test:");
        $this->line("Template: {$template}");
        $this->line("Language: {$language}");
        $this->line("To: {$phone}");
        if (!empty($parameters)) {
            $this->line("Parameters: " . implode(', ', $parameters));
        }

        try {
            
            $result = $metaService->sendTemplate(
                to: $phone,
                templateName: $template,
                languageCode: $language,
                parameters: $parameters
            );

            if ($result['success']) {
                $messageId = $result['messages'][0]['id'] ?? null;
                $this->info("✅ Template message sent successfully!");
                $this->line("📬 Message ID: " . ($messageId ?? 'N/A'));
                $this->line("📞 To: " . $result['to']);
                $this->line("📋 Template: " . $result['template']);
                $this->line("👤 Contact ID: " . ($result['contacts'][0]['wa_id'] ?? 'N/A'));
                $this->line("📊 Status: " . ($result['messages'][0]['message_status'] ?? 'N/A'));
                return $messageId;
            } else {
                $this->error("❌ Failed to send template message:");
                $this->line("Error: " . $result['error']);
                $this->line("Code: " . $result['code']);
            }
        } catch (\Exception $e) {
            $this->error("💥 Exception: " . $e->getMessage());
        }

        $this->newLine();
        return null;
    }

    private function checkMessageTemplates(): void
    {
        $this->info("📋 Message Templates (Production Diagnostics):");

        $accessToken = config('services.meta.access_token');
        $accountId = config('services.meta.whatsapp_business_account_id');

        try {
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $accessToken,
            ])->get("https://graph.facebook.com/v18.0/{$accountId}/message_templates", [
                'fields' => 'name,status,category,language',
                'limit' => 20
            ]);

            if ($response->successful()) {
                $data = $response->json();

                if (!empty($data['data'])) {
                    $this->line("📨 Available Templates:");
                    foreach ($data['data'] as $template) {
                        $status = $template['status'] ?? 'Unknown';
                        $icon = $status === 'APPROVED' ? '✅' : '⚠️';
                        $this->line("   {$icon} {$template['name']} ({$status}) - {$template['category']} [{$template['language']}]");
                    }

                    $approvedTemplates = array_filter($data['data'], fn($t) => ($t['status'] ?? '') === 'APPROVED');
                    if (empty($approvedTemplates)) {
                        $this->error("❌ No APPROVED templates found!");
                        $this->line("💡 Create templates at: https://business.facebook.com/wa/manage/message-templates/");
                    }
                } else {
                    $this->error("❌ No message templates found!");
                }
            } else {
                $this->error("❌ Cannot check templates: " . $response->body());
            }
        } catch (\Exception $e) {
            $this->error("💥 Exception: " . $e->getMessage());
        }

        $this->newLine();
    }

    private function checkBusinessVerification(): void
    {
        $this->info("🏢 Business Verification Status:");

        $accessToken = config('services.meta.access_token');
        $accountId = config('services.meta.whatsapp_business_account_id');
        $phoneNumberId = config('services.meta.phone_number_id');

        try {
            // Check phone number details for production readiness
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $accessToken,
            ])->get("https://graph.facebook.com/v18.0/{$phoneNumberId}", [
                'fields' => 'status,quality_rating,messaging_limit_tier,name_status'
            ]);

            if ($response->successful()) {
                $data = $response->json();
                $this->line("Status: " . ($data['status'] ?? 'Unknown'));
                $this->line("Quality Rating: " . ($data['quality_rating'] ?? 'Unknown'));
                $this->line("Messaging Limit: " . ($data['messaging_limit_tier'] ?? 'Unknown'));
                $this->line("Name Status: " . ($data['name_status'] ?? 'Unknown'));

                // Production readiness check
                if (($data['status'] ?? '') === 'CONNECTED' &&
                    in_array(($data['quality_rating'] ?? ''), ['GREEN', 'YELLOW'])) {
                    $this->info("✅ Phone number ready for production");
                } else {
                    $this->warn("⚠️  Phone number may have production limitations");
                }
            } else {
                $this->error("❌ Cannot check business verification");
            }
        } catch (\Exception $e) {
            $this->error("💥 Exception: " . $e->getMessage());
        }

        $this->newLine();
    }
}
