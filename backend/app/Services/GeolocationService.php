<?php

namespace App\Services;

class GeolocationService
{
    /**
     * Calculate distance between two coordinates using Haversine formula
     * 
     * @param float $lat1 Latitude of the first point
     * @param float $lon1 Longitude of the first point
     * @param float $lat2 Latitude of the second point
     * @param float $lon2 Longitude of the second point
     * @return float Distance in meters
     */
    public function calculateDistance(float $lat1, float $lon1, float $lat2, float $lon2): float
    {
        $earthRadius = 6371000; // Earth's radius in meters
        
        $dLat = deg2rad($lat2 - $lat1);
        $dLon = deg2rad($lon2 - $lon1);
        
        $a = sin($dLat / 2) * sin($dLat / 2) +
             cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
             sin($dLon / 2) * sin($dLon / 2);
        
        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
        
        return $earthRadius * $c;
    }

    /**
     * Check if a point is within a certain radius of another point
     * 
     * @param float $lat1 Latitude of the first point
     * @param float $lon1 Longitude of the first point
     * @param float $lat2 Latitude of the second point
     * @param float $lon2 Longitude of the second point
     * @param float $radiusMeters Radius in meters
     * @return bool True if the point is within the radius
     */
    public function isWithinRadius(
        float $lat1, 
        float $lon1, 
        float $lat2, 
        float $lon2, 
        float $radiusMeters
    ): bool {
        $distance = $this->calculateDistance($lat1, $lon1, $lat2, $lon2);
        return $distance <= $radiusMeters;
    }

    /**
     * Convert distance from meters to kilometers
     * 
     * @param float $meters Distance in meters
     * @return float Distance in kilometers
     */
    public function metersToKilometers(float $meters): float
    {
        return $meters / 1000;
    }

    /**
     * Convert distance from kilometers to meters
     * 
     * @param float $kilometers Distance in kilometers
     * @return float Distance in meters
     */
    public function kilometersToMeters(float $kilometers): float
    {
        return $kilometers * 1000;
    }

    /**
     * Format distance for human readable display
     * 
     * @param float $meters Distance in meters
     * @param int $precision Number of decimal places
     * @return string Formatted distance string
     */
    public function formatDistance(float $meters, int $precision = 0): string
    {
        if ($meters >= 1000) {
            $km = $meters / 1000;
            return number_format($km, $precision) . ' km';
        }
        
        return number_format($meters, $precision) . ' m';
    }
}
