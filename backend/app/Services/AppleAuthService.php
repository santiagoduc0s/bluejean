<?php

namespace App\Services;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;

class AppleAuthService
{
    private const APPLE_KEYS_URL = 'https://appleid.apple.com/auth/keys';
    private const APPLE_ISSUER = 'https://appleid.apple.com';
    private const CACHE_KEY = 'apple_public_keys';
    private const CACHE_TTL = 3600; // 1 hour

    /**
     * Verify Apple ID token and extract user information.
     *
     * @param string $idToken
     * @return object
     * @throws \Exception
     */
    public function verifyAppleIdToken(string $idToken): object
    {
        // Log environment information for debugging
        $this->logEnvironmentInfo();

        $header = JWT::jsonDecode(
            JWT::urlsafeB64Decode(
                explode('.', $idToken)[0],
            ),
        );

        $keyId = $header->kid;
        Log::info('Apple Sign-In: Processing token', ['key_id' => $keyId]);

        $appleKeys = $this->getApplePublicKeys();

        if (!isset($appleKeys[$keyId])) {
            Log::error('Apple Sign-In: Public key not found', [
                'key_id' => $keyId,
                'available_keys' => array_keys($appleKeys)
            ]);
            throw new \Exception('Apple public key not found for key ID: ' . $keyId);
        }

        $publicKey = $appleKeys[$keyId];
        Log::info('Apple Sign-In: Using public key', [
            'key_id' => $keyId,
            'key_length' => strlen($publicKey),
            'key_preview' => substr($publicKey, 0, 100) . '...'
        ]);

        try {
            $decoded = JWT::decode(
                jwt: $idToken,
                keyOrKeyArray: new Key(
                    keyMaterial: $publicKey,
                    algorithm: 'RS256',
                ),
            );

            Log::info('Apple Sign-In: Token decoded successfully');
            $this->validateAppleTokenClaims($decoded);

            return $decoded;
        } catch (\Exception $e) {
            Log::error('Apple Sign-In: JWT decode failed', [
                'error' => $e->getMessage(),
                'key_id' => $keyId,
                'openssl_version' => OPENSSL_VERSION_TEXT ?? 'unknown'
            ]);
            throw $e;
        }
    }

    /**
     * Get Apple public keys for token verification.
     *
     * @return array
     * @throws \Exception
     */
    private function getApplePublicKeys(): array
    {
        // Check if we have OpenSSL 3.x and need to refresh cache
        $cacheKey = self::CACHE_KEY;
        $opensslVersion = OPENSSL_VERSION_TEXT ?? '';
        if (strpos($opensslVersion, 'OpenSSL 3.') !== false) {
            $cacheKey = self::CACHE_KEY . '_openssl3';
        }

        $cachedKeys = Cache::get($cacheKey);
        if ($cachedKeys) {
            Log::info('Apple Sign-In: Using cached keys', ['cache_key' => $cacheKey]);
            
            // Validate cached keys for OpenSSL 3.x compatibility
            if (strpos($opensslVersion, 'OpenSSL 3.') !== false) {
                $validKeys = [];
                foreach ($cachedKeys as $keyId => $pemKey) {
                    if ($this->validatePemKey($pemKey)) {
                        $validKeys[$keyId] = $pemKey;
                    } else {
                        Log::warning('Apple Sign-In: Cached key invalid for OpenSSL 3.x', ['key_id' => $keyId]);
                    }
                }
                
                if (count($validKeys) === count($cachedKeys)) {
                    return $cachedKeys;
                } else {
                    Log::info('Apple Sign-In: Some cached keys invalid, refreshing cache');
                    Cache::forget($cacheKey);
                }
            } else {
                return $cachedKeys;
            }
        }

        Log::info('Apple Sign-In: Fetching fresh Apple public keys');
        $response = Http::timeout(10)->get(self::APPLE_KEYS_URL);

        if (!$response->successful()) {
            throw new \Exception('Failed to fetch Apple public keys');
        }

        $keysData = $response->json();
        $keys = [];

        foreach ($keysData['keys'] as $key) {
            $keys[$key['kid']] = $this->convertJwkToPem($key);
        }

        Cache::put($cacheKey, $keys, self::CACHE_TTL);
        Log::info('Apple Sign-In: Cached new keys', [
            'cache_key' => $cacheKey,
            'key_count' => count($keys),
            'key_ids' => array_keys($keys)
        ]);

        return $keys;
    }

    /**
     * Convert JWK (JSON Web Key) to PEM format.
     *
     * @param array $jwk
     * @return string
     */
    private function convertJwkToPem(array $jwk): string
    {
        $keyId = $jwk['kid'] ?? 'unknown';
        Log::info('Apple Sign-In: Converting JWK to PEM', [
            'key_id' => $keyId,
            'memory_before' => memory_get_usage(),
            'memory_peak' => memory_get_peak_usage()
        ]);

        try {
            // Try the existing method first
            $pem = $this->convertJwkToPemStandard($jwk);
            
            // Validate the generated PEM key
            if ($this->validatePemKey($pem)) {
                Log::info('Apple Sign-In: PEM conversion successful (standard method)', ['key_id' => $keyId]);
                return $pem;
            } else {
                Log::warning('Apple Sign-In: Standard PEM conversion failed validation, trying fallback', ['key_id' => $keyId]);
                return $this->convertJwkToPemFallback($jwk);
            }
        } catch (\Exception $e) {
            Log::error('Apple Sign-In: PEM conversion failed', [
                'key_id' => $keyId,
                'error' => $e->getMessage(),
                'memory_after' => memory_get_usage()
            ]);
            
            // Try fallback method
            return $this->convertJwkToPemFallback($jwk);
        }
    }

    /**
     * Standard JWK to PEM conversion method.
     */
    private function convertJwkToPemStandard(array $jwk): string
    {
        $n = JWT::urlsafeB64Decode($jwk['n']);
        $e = JWT::urlsafeB64Decode($jwk['e']);

        // Ensure proper padding for OpenSSL 3.x compatibility
        if (ord($n[0]) & 0x80) {
            $n = "\x00" . $n;
        }

        // Use proper hex formatting with padding
        $nHex = bin2hex($n);
        $eHex = bin2hex($e);
        $nLen = strlen($nHex) / 2;
        $eLen = strlen($eHex) / 2;

        // Calculate total length for proper DER encoding
        $innerLen = $nLen + $eLen + 6; // 6 bytes for INTEGER headers and lengths
        $bitStringLen = $innerLen + 3; // 3 bytes for SEQUENCE header and length
        $totalLen = $bitStringLen + 15; // 15 bytes for algorithm identifier

        $der = pack(
            'H*',
            '30' . sprintf('%02x', $totalLen) .                    // SEQUENCE
            '300d' .                                               // SEQUENCE (AlgorithmIdentifier)
            '06092a864886f70d0101010500' .                        // OBJECT IDENTIFIER + NULL
            '03' . sprintf('%02x', $bitStringLen) . '00' .         // BIT STRING
            '30' . sprintf('%02x', $innerLen) .                    // SEQUENCE (RSAPublicKey)
            '02' . sprintf('%02x', $nLen) . $nHex .                // INTEGER (modulus)
            '02' . sprintf('%02x', $eLen) . $eHex                  // INTEGER (exponent)
        );

        $pem = "-----BEGIN PUBLIC KEY-----\n";
        $pem .= chunk_split(base64_encode($der), 64, "\n");
        $pem .= "-----END PUBLIC KEY-----\n";

        return $pem;
    }

    /**
     * Fallback JWK to PEM conversion method using a different approach.
     */
    private function convertJwkToPemFallback(array $jwk): string
    {
        $keyId = $jwk['kid'] ?? 'unknown';
        Log::info('Apple Sign-In: Using fallback PEM conversion', ['key_id' => $keyId]);

        // Use a more straightforward ASN.1 encoding approach
        $n = JWT::urlsafeB64Decode($jwk['n']);
        $e = JWT::urlsafeB64Decode($jwk['e']);

        // Ensure modulus has the right padding
        if (ord($n[0]) > 127) {
            $n = "\x00" . $n;
        }

        // Build the ASN.1 structure more carefully
        $modulusLength = strlen($n);
        $exponentLength = strlen($e);
        
        $rsaPublicKey = pack('Ca*Ca*', 2, $this->encodeLength($modulusLength) . $n, 2, $this->encodeLength($exponentLength) . $e);
        $rsaPublicKeyLength = strlen($rsaPublicKey);
        
        $publicKeySequence = pack('Ca*', 48, $this->encodeLength($rsaPublicKeyLength) . $rsaPublicKey);
        
        $algorithm = pack('H*', '300d06092a864886f70d0101010500');
        $publicKeyBitString = pack('Ca*', 3, $this->encodeLength(strlen($publicKeySequence) + 1) . "\x00" . $publicKeySequence);
        
        $publicKeyInfo = pack('Ca*', 48, $this->encodeLength(strlen($algorithm) + strlen($publicKeyBitString)) . $algorithm . $publicKeyBitString);

        $pem = "-----BEGIN PUBLIC KEY-----\n";
        $pem .= chunk_split(base64_encode($publicKeyInfo), 64, "\n");
        $pem .= "-----END PUBLIC KEY-----";

        return $pem;
    }

    /**
     * Encode ASN.1 length field.
     */
    private function encodeLength(int $length): string
    {
        if ($length < 128) {
            return chr($length);
        }
        
        $encoded = '';
        while ($length > 0) {
            $encoded = chr($length & 0xFF) . $encoded;
            $length >>= 8;
        }
        
        return chr(0x80 | strlen($encoded)) . $encoded;
    }

    /**
     * Validate if a PEM key is properly formatted and usable.
     */
    private function validatePemKey(string $pem): bool
    {
        try {
            $resource = openssl_pkey_get_public($pem);
            if ($resource === false) {
                return false;
            }
            openssl_free_key($resource);
            return true;
        } catch (\Exception $e) {
            Log::warning('Apple Sign-In: PEM validation failed', ['error' => $e->getMessage()]);
            return false;
        }
    }

    /**
     * Log environment information for debugging.
     */
    private function logEnvironmentInfo(): void
    {
        static $logged = false;
        
        if (!$logged) {
            $opensslVersion = OPENSSL_VERSION_TEXT ?? 'unknown';
            Log::info('Apple Sign-In: Environment Info', [
                'php_version' => PHP_VERSION,
                'openssl_version' => $opensslVersion,
                'memory_limit' => ini_get('memory_limit'),
                'max_execution_time' => ini_get('max_execution_time'),
                'openssl_extensions' => extension_loaded('openssl'),
                'jwt_library_version' => class_exists('Firebase\JWT\JWT') ? 'loaded' : 'missing'
            ]);
            
            // Clear old cache for OpenSSL 3.x compatibility
            if (strpos($opensslVersion, 'OpenSSL 3.') !== false) {
                $oldCacheCleared = Cache::forget(self::CACHE_KEY);
                if ($oldCacheCleared) {
                    Log::info('Apple Sign-In: Cleared old cache for OpenSSL 3.x compatibility');
                }
            }
            
            $logged = true;
        }
    }

    /**
     * Clear Apple public key cache (useful for debugging)
     */
    public function clearKeyCache(): void
    {
        Cache::forget(self::CACHE_KEY);
        Cache::forget(self::CACHE_KEY . '_openssl3');
        Log::info('Apple Sign-In: Key cache cleared manually');
    }

    /**
     * Validate Apple ID token claims.
     *
     * @param object $decoded
     * @throws \Exception
     */
    private function validateAppleTokenClaims(object $decoded): void
    {
        $now = time();

        if ($decoded->iss !== self::APPLE_ISSUER) {
            throw new \Exception('Invalid Apple token issuer');
        }

        if ($decoded->exp < $now) {
            throw new \Exception('Apple token has expired');
        }

        if (isset($decoded->nbf) && $decoded->nbf > $now) {
            throw new \Exception('Apple token not yet valid');
        }

        if (isset($decoded->iat) && ($decoded->iat > $now + 300 || $decoded->iat < $now - 3600)) {
            throw new \Exception('Apple token issued at invalid time');
        }

        if (empty($decoded->sub)) {
            throw new \Exception('Apple token missing subject (user ID)');
        }

        if (empty($decoded->aud)) {
            throw new \Exception('Apple token missing audience');
        }

        // Note: In production, you should also validate the audience (aud)
        // matches your app's bundle ID
    }

    /**
     * Extract user data from verified Apple ID token.
     *
     * @param object $decodedToken
     * @return array
     */
    public function extractUserDataFromToken(object $decodedToken): array
    {
        return [
            'apple_id' => $decodedToken->sub,
            'email' => $decodedToken->email ?? null,
        ];
    }
}
