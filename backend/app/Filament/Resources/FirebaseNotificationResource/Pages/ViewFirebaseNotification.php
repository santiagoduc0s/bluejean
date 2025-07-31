<?php

namespace App\Filament\Resources\FirebaseNotificationResource\Pages;

use App\Filament\Resources\FirebaseNotificationResource;
use App\Models\User;
use App\Repositories\Contracts\MessagingRepositoryInterface;
use Filament\Actions;
use Filament\Resources\Pages\ViewRecord;
use Filament\Notifications\Notification;
use Illuminate\Support\Facades\Log;

class ViewFirebaseNotification extends ViewRecord
{
    protected static string $resource = FirebaseNotificationResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\Action::make('send_again')
                ->label('Send Again')
                ->icon('heroicon-o-paper-airplane')
                ->color('primary')
                ->requiresConfirmation()
                ->modalHeading('Send Notification Again')
                ->modalDescription(function () {
                    $record = $this->record;
                    if ($record->user_id) {
                        return "Are you sure you want to send this notification again to {$record->user->email}?";
                    }
                    return "Are you sure you want to send this notification again to the same FCM token?";
                })
                ->modalSubmitActionLabel('Send Now')
                ->visible(function () {
                    // Only show if the notification has user_id (user-based) or if it's a single token send
                    return $this->record->user_id !== null || 
                           ($this->record->user_id === null && $this->record->fcm_token !== null);
                })
                ->action('sendAgain'),
        ];
    }

    public function sendAgain(): void
    {
        $record = $this->record;
        
        try {
            $messagingRepository = app(MessagingRepositoryInterface::class);
            
            if ($record->user_id) {
                // Send to user (all their devices)
                $result = $messagingRepository->sendNotificationToUser(
                    title: $record->title,
                    body: $record->body,
                    userId: $record->user_id,
                    data: $record->data ?? []
                );

                $successMessage = sprintf(
                    'Notification sent again to user! Batch ID: %s - %d devices targeted, %d successful, %d failed (%.1f%% success rate)',
                    $result['batch_id'],
                    $result['total_devices'],
                    $result['successful_devices'],
                    $result['failed_devices'],
                    $result['success_rate']
                );

                if ($result['success_rate'] >= 90) {
                    Notification::make()
                        ->title('Notification Sent Successfully!')
                        ->body($successMessage)
                        ->success()
                        ->duration(10000)
                        ->send();
                } elseif ($result['success_rate'] >= 50) {
                    Notification::make()
                        ->title('Notification Sent with Some Issues')
                        ->body($successMessage)
                        ->warning()
                        ->duration(10000)
                        ->send();
                } else {
                    Notification::make()
                        ->title('Notification Send Failed')
                        ->body($successMessage)
                        ->danger()
                        ->duration(10000)
                        ->send();
                }

                Log::info('Notification sent again via Filament view', [
                    'original_notification_id' => $record->id,
                    'new_batch_id' => $result['batch_id'],
                    'admin_user' => auth()->user()->email,
                    'target_user_id' => $record->user_id,
                    'title' => $record->title,
                ]);

            } else {
                // Send to direct FCM token
                $success = $messagingRepository->sendNotificationToToken(
                    title: $record->title,
                    body: $record->body,
                    fcmToken: $record->fcm_token,
                    data: $record->data ?? []
                );

                if ($success) {
                    Notification::make()
                        ->title('Notification Sent Successfully!')
                        ->body('Direct notification sent to FCM token successfully.')
                        ->success()
                        ->send();
                } else {
                    Notification::make()
                        ->title('Notification Send Failed')
                        ->body('Failed to send notification to FCM token.')
                        ->danger()
                        ->send();
                }

                Log::info('Direct notification sent again via Filament view', [
                    'original_notification_id' => $record->id,
                    'admin_user' => auth()->user()->email,
                    'fcm_token' => $record->fcm_token,
                    'title' => $record->title,
                    'success' => $success,
                ]);
            }

        } catch (\Exception $e) {
            Notification::make()
                ->title('Failed to Send Notification')
                ->body('Error: ' . $e->getMessage())
                ->danger()
                ->send();

            Log::error('Failed to send notification again via Filament view', [
                'original_notification_id' => $record->id,
                'error' => $e->getMessage(),
                'admin_user' => auth()->user()->email,
                'title' => $record->title,
            ]);
        }
    }
}