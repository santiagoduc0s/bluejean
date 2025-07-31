<?php

namespace App\Repositories;

use App\Repositories\Contracts\MessagingRepositoryInterface;
use App\Models\FirebaseNotification;
use App\Models\User;
use App\Models\Device;
use Kreait\Firebase\Contract\Messaging;
use Kreait\Firebase\Exception\MessagingException;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class MessagingRepository implements MessagingRepositoryInterface
{
    protected Messaging $messaging;

    public function __construct(Messaging $messaging)
    {
        $this->messaging = $messaging;
    }

    /**
     * Send notification to multiple users (all their devices)
     */
    public function sendNotificationToUsers(string $title, string $body, array $userIds, array $data = []): array
    {
        if (empty($userIds)) {
            return [];
        }

        $batchId = Str::uuid()->toString();

        // Get users with their devices and preferences
        $users = User::whereIn('id', $userIds)
            ->with(['devices' => function($query) {
                $query->whereNotNull('fcm_token');
            }, 'preference'])
            ->get();

        $results = [];
        $totalDevices = 0;
        $successfulDevices = 0;
        $failedDevices = 0;

        foreach ($users as $user) {
            // Check if user has notifications enabled
            if (!$this->userHasNotificationsEnabled($user)) {
                Log::info("User has notifications disabled, skipping", [
                    'user_id' => $user->id,
                    'batch_id' => $batchId
                ]);
                continue;
            }

            $userResults = [];

            foreach ($user->devices as $device) {
                if (empty($device->fcm_token)) {
                    continue;
                }

                $totalDevices++;

                // Create individual notification record
                $firebaseNotification = FirebaseNotification::create([
                    'batch_id' => $batchId,
                    'user_id' => $user->id,
                    'device_id' => $device->id,
                    'fcm_token' => $device->fcm_token,
                    'title' => $title,
                    'body' => $body,
                    'data' => $data,
                    'status' => 'pending',
                ]);

                // Send notification
                $success = $this->sendToDevice($firebaseNotification, $data);

                if ($success) {
                    $successfulDevices++;
                } else {
                    $failedDevices++;
                }

                $userResults[] = [
                    'device_id' => $device->id,
                    'fcm_token' => $device->fcm_token,
                    'success' => $success,
                    'notification_id' => $firebaseNotification->id,
                ];
            }

            $results[$user->id] = [
                'user_id' => $user->id,
                'devices' => $userResults,
                'total_devices' => count($userResults),
                'successful_devices' => count(array_filter($userResults, fn($r) => $r['success'])),
            ];
        }

        return [
            'batch_id' => $batchId,
            'total_users' => count($users),
            'total_devices' => $totalDevices,
            'successful_devices' => $successfulDevices,
            'failed_devices' => $failedDevices,
            'success_rate' => $totalDevices > 0 ? round(($successfulDevices / $totalDevices) * 100, 2) : 0,
            'results' => $results,
        ];
    }

    /**
     * Send notification to a single user (all their devices)
     */
    public function sendNotificationToUser(string $title, string $body, int $userId, array $data = []): array
    {
        $result = $this->sendNotificationToUsers($title, $body, [$userId], $data);

        return [
            'batch_id' => $result['batch_id'],
            'user_id' => $userId,
            'total_devices' => $result['total_devices'],
            'successful_devices' => $result['successful_devices'],
            'failed_devices' => $result['failed_devices'],
            'success_rate' => $result['success_rate'],
            'devices' => $result['results'][$userId]['devices'] ?? [],
        ];
    }

    /**
     * Send notification to a single FCM token (direct)
     */
    public function sendNotificationToToken(string $title, string $body, string $fcmToken, array $data = []): bool
    {
        $batchId = Str::uuid()->toString();

        // Create notification record
        $firebaseNotification = FirebaseNotification::create([
            'batch_id' => $batchId,
            'user_id' => null,
            'device_id' => null,
            'fcm_token' => $fcmToken,
            'title' => $title,
            'body' => $body,
            'data' => $data,
            'status' => 'pending',
        ]);

        return $this->sendToDevice($firebaseNotification, $data);
    }

    /**
     * Send notification to a topic
     */
    public function sendNotificationToTopic(string $title, string $body, string $topic, array $data = []): bool
    {
        $batchId = Str::uuid()->toString();

        // Create notification record
        $firebaseNotification = FirebaseNotification::create([
            'batch_id' => $batchId,
            'user_id' => null,
            'device_id' => null,
            'fcm_token' => null,
            'title' => $title,
            'body' => $body,
            'data' => $data,
            'status' => 'pending',
        ]);

        try {
            $notification = Notification::create($title, $body);

            $message = CloudMessage::new()
                ->withNotification($notification)
                ->toTopic($topic);

            if (!empty($data)) {
                $message = $message->withData($data);
            }

            $response = $this->messaging->send($message);

            // Update success
            $firebaseNotification->update([
                'status' => 'success',
                'firebase_message_id' => $response['name'] ?? null,
                'sent_at' => now(),
            ]);

            Log::info("Firebase topic notification sent successfully", [
                'notification_id' => $firebaseNotification->id,
                'batch_id' => $batchId,
                'topic' => $topic,
                'title' => $title
            ]);

            return true;

        } catch (MessagingException $e) {
            // Update failure
            $firebaseNotification->update([
                'status' => 'error',
                'error_message' => $e->getMessage(),
            ]);

            Log::error("Firebase topic notification failed", [
                'notification_id' => $firebaseNotification->id,
                'batch_id' => $batchId,
                'topic' => $topic,
                'title' => $title,
                'error' => $e->getMessage()
            ]);

            return false;
        }
    }

    /**
     * Get batch statistics
     */
    public function getBatchStats(string $batchId): array
    {
        return FirebaseNotification::getBatchStats($batchId);
    }

    /**
     * Send notification to a specific device
     */
    private function sendToDevice(FirebaseNotification $firebaseNotification, array $data = []): bool
    {
        try {
            $notification = Notification::create($firebaseNotification->title, $firebaseNotification->body);

            $message = CloudMessage::new()
                ->withNotification($notification)
                ->toToken($firebaseNotification->fcm_token);

            if (!empty($data)) {
                $message = $message->withData($data);
            }

            $response = $this->messaging->send($message);

            // Update success
            $firebaseNotification->update([
                'status' => 'success',
                'firebase_message_id' => $response['name'] ?? null,
                'sent_at' => now(),
            ]);

            Log::info("Firebase notification sent successfully", [
                'notification_id' => $firebaseNotification->id,
                'batch_id' => $firebaseNotification->batch_id,
                'user_id' => $firebaseNotification->user_id,
                'device_id' => $firebaseNotification->device_id,
                'title' => $firebaseNotification->title
            ]);

            return true;

        } catch (MessagingException $e) {
            // Update failure
            $firebaseNotification->update([
                'status' => 'error',
                'error_message' => $e->getMessage(),
            ]);

            Log::error("Firebase notification failed", [
                'notification_id' => $firebaseNotification->id,
                'batch_id' => $firebaseNotification->batch_id,
                'user_id' => $firebaseNotification->user_id,
                'device_id' => $firebaseNotification->device_id,
                'title' => $firebaseNotification->title,
                'error' => $e->getMessage()
            ]);

            return false;
        }
    }

    /**
     * Check if user has notifications enabled
     */
    private function userHasNotificationsEnabled(User $user): bool
    {
        // If user has no preference, assume notifications are enabled
        if (!$user->preference) {
            return true;
        }

        return $user->preference->notifications_are_enabled;
    }
}
