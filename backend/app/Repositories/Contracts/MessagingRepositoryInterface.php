<?php

namespace App\Repositories\Contracts;

interface MessagingRepositoryInterface
{
    /**
     * Send notification to multiple users (all their devices)
     *
     * @param string $title
     * @param string $body
     * @param array $userIds
     * @param array $data Additional data payload (optional)
     * @return array Returns batch results with batch_id and individual device results
     */
    public function sendNotificationToUsers(string $title, string $body, array $userIds, array $data = []): array;

    /**
     * Send notification to a single user (all their devices)
     *
     * @param string $title
     * @param string $body
     * @param int $userId
     * @param array $data Additional data payload (optional)
     * @return array Returns results for user's devices
     */
    public function sendNotificationToUser(string $title, string $body, int $userId, array $data = []): array;

    /**
     * Send notification to a single FCM token (direct)
     *
     * @param string $title
     * @param string $body
     * @param string $fcmToken
     * @param array $data Additional data payload (optional)
     * @return bool
     */
    public function sendNotificationToToken(string $title, string $body, string $fcmToken, array $data = []): bool;

    /**
     * Send notification to a topic
     *
     * @param string $title
     * @param string $body
     * @param string $topic
     * @param array $data Additional data payload (optional)
     * @return bool
     */
    public function sendNotificationToTopic(string $title, string $body, string $topic, array $data = []): bool;

    /**
     * Get batch statistics
     *
     * @param string $batchId
     * @return array
     */
    public function getBatchStats(string $batchId): array;
}