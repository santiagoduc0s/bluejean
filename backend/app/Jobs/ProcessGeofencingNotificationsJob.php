<?php

namespace App\Jobs;

use App\Models\DriverPosition;
use App\Models\Listener;
use App\Models\ListenerNotification;
use App\Services\GeolocationService;
use App\Services\MetaService;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

/**
 * Geofencing Notifications Job
 *
 * Processes geofencing notifications for driver positions.
 * Sends WhatsApp notifications via Meta Business API using approved templates.
 * Can be run synchronously or asynchronously via queue.
 */
class ProcessGeofencingNotificationsJob implements ShouldQueue
{
    use Queueable, InteractsWithQueue, SerializesModels;

    /**
     * The driver position to check against listeners
     */
    private DriverPosition $driverPosition;

    /**
     * The number of times the job may be attempted.
     */
    public int $tries = 3;

    /**
     * The number of seconds the job can run before timing out.
     */
    public int $timeout = 60;

    /**
     * Create a new job instance.
     */
    public function __construct(DriverPosition $driverPosition)
    {
        $this->driverPosition = $driverPosition;
    }

    /**
     * Execute the job.
     */
    public function handle(
        MetaService $metaService,
        GeolocationService $geolocationService,
    ): void {
        $user = $this->driverPosition->user;

        $listeners = Listener::whereIn(
            'channel_id',
            $user->channels()
                ->where('channels.status', 'active')
                ->pluck('channels.id')
        )
            ->where('status', 'active')
            ->whereNotNull('latitude')
            ->whereNotNull('longitude')
            ->whereNotNull('threshold_meters')
            ->get();

        foreach ($listeners as $listener) {
            $this->processListener(
                listener: $listener,
                metaService: $metaService,
                geolocationService: $geolocationService,
            );
        }
    }

    private function processListener(
        Listener $listener,
        MetaService $metaService,
        GeolocationService $geolocationService,
    ): void {
        Log::info('Checking if within radius', [
            'is_in' =>  $geolocationService->isWithinRadius(
                lat1: $this->driverPosition->latitude,
                lon1: $this->driverPosition->longitude,
                lat2: $listener->latitude,
                lon2: $listener->longitude,
                radiusMeters: (float) $listener->threshold_meters
            )
        ]);
        if (
            $geolocationService->isWithinRadius(
                lat1: $this->driverPosition->latitude,
                lon1: $this->driverPosition->longitude,
                lat2: $listener->latitude,
                lon2: $listener->longitude,
                radiusMeters: (float) $listener->threshold_meters
            )
        ) {
            if ($listener->canSendNotification()) {
                $this->createNotification(
                    listener: $listener,
                    metaService: $metaService,
                    geolocationService: $geolocationService,
                );
            }
        }
    }

    private function createNotification(
        Listener $listener,
        MetaService $metaService,
        GeolocationService $geolocationService,
    ): void {
        $distance = $geolocationService->calculateDistance(
            lat1: $this->driverPosition->latitude,
            lon1: $this->driverPosition->longitude,
            lat2: $listener->latitude,
            lon2: $listener->longitude
        );

        $formattedDistance = $geolocationService->formatDistance($distance);

        // $title = __('notifications.bus_near_title');

        // if ($listener->address) {
        //     // $body = __('notifications.bus_near_body_with_address', [
        //     $body = __('notifications.bus_near_body', [
        //         'distance' => $formattedDistance,
        //         'listener_name' => $listener->name,
        //         // 'address' => $listener->address
        //     ]);
        // } else {
        //     $body = __('notifications.bus_near_body', [
        //         'distance' => $formattedDistance,
        //         'listener_name' => $listener->name
        //     ]);
        // }

        $template = 'driver_approaching';

        ListenerNotification::create([
            'listener_id' => $listener->id,
            'driver_position_id' => $this->driverPosition->id,
            'type' => $template,
        ]);

        try {
            $result = $metaService->sendTemplate(
                to: $listener->phone_number,
                templateName: $template,
                languageCode: 'es',
                parameters: [$formattedDistance]
            );

            if ($result['success']) {
                Log::info('WhatsApp template notification sent successfully', [
                    'phone' => $listener->phone_number,
                    'template' => $template,
                    'message_id' => $result['messages'][0]['id'] ?? null,
                    'listener_id' => $listener->id,
                    'distance' => $formattedDistance
                ]);
            } else {
                Log::error('WhatsApp template notification failed', [
                    'phone' => $listener->phone_number,
                    'template' => $template,
                    'error' => $result['error'] ?? 'Unknown error',
                    'code' => $result['code'] ?? 'No code',
                    'listener_id' => $listener->id
                ]);
            }
        } catch (\Exception $e) {
            Log::error('WhatsApp notification exception', [
                'phone' => $listener->phone_number,
                'template' => $template,
                'error' => $e->getMessage(),
                'listener_id' => $listener->id
            ]);
        }
    }

    public function failed(\Throwable $exception): void
    {
        Log::error('Geofencing job failed', [
            'driver_position_id' => $this->driverPosition->id,
            'user_id' => $this->driverPosition->user_id,
            'exception' => $exception->getMessage(),
            'trace' => $exception->getTraceAsString(),
        ]);
    }
}
