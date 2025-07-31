<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class GoogleAuthService
{
    private const GOOGLE_TOKENINFO_URL = 'https://oauth2.googleapis.com/tokeninfo';
    private const VALID_ISSUERS = ['accounts.google.com', 'https://accounts.google.com'];

    /**
     * Verify Google ID token and return user data
     *
     * @param string $idToken
     * @return array
     * @throws \Exception
     */
    public function verifyGoogleIdToken(string $idToken): array
    {
        $response = Http::get(self::GOOGLE_TOKENINFO_URL, [
            'id_token' => $idToken
        ]);

        if (!$response->successful()) {
            throw new \Exception('Failed to verify token with Google: ' . $response->body());
        }

        $payload = $response->json();

        $expectedClientId = config('services.google.client_id');
        if ($payload['aud'] !== $expectedClientId) {
            throw new \Exception('Token audience mismatch. Expected: ' . $expectedClientId . ', Got: ' . $payload['aud']);
        }

        if (!in_array($payload['iss'], self::VALID_ISSUERS)) {
            throw new \Exception('Invalid token issuer: ' . $payload['iss']);
        }

        $userData = [
            'google_id' => $payload['sub'],
            'email' => $payload['email'],
            'email_verified' => $payload['email_verified'] === 'true',
            'audience' => $payload['aud'],
            'issuer' => $payload['iss']
        ];

        return $userData;
    }

    /**
     * Extract user data from verified token payload
     *
     * @param array $tokenData
     * @return array
     */
    public function extractUserDataFromToken(array $tokenData): array
    {
        return [
            'google_id' => $tokenData['google_id'],
            'email' => $tokenData['email'],
        ];
    }
}
