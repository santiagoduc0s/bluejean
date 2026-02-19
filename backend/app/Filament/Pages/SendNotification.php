<?php

namespace App\Filament\Pages;

use App\Models\User;
use App\Repositories\Contracts\MessagingRepositoryInterface;
use Filament\Forms;
use Filament\Schemas\Schema;
use Filament\Pages\Page;
use Filament\Actions\Action;
use Filament\Notifications\Notification;
use Illuminate\Support\Facades\Log;

class SendNotification extends Page
{
    protected static string|\BackedEnum|null $navigationIcon = 'heroicon-o-paper-airplane';

    protected static ?string $navigationLabel = 'Send Notification';
    
    protected static string|\UnitEnum|null $navigationGroup = 'Push Notifications';

    protected string $view = 'filament.pages.send-notification';

    public ?array $data = [];

    public function mount(): void
    {
        $this->form->fill();
    }

    public function form(Schema $schema): Schema
    {
        return $schema
            ->schema([
                Forms\Components\Section::make('Notification Content')
                    ->schema([
                        Forms\Components\TextInput::make('title')
                            ->label('Title')
                            ->required()
                            ->maxLength(255)
                            ->placeholder('Enter notification title'),

                        Forms\Components\Textarea::make('body')
                            ->label('Message Body')
                            ->required()
                            ->rows(4)
                            ->maxLength(1000)
                            ->placeholder('Enter your notification message'),

                        Forms\Components\KeyValue::make('data')
                            ->label('Custom Data (Optional)')
                            ->addActionLabel('Add custom field')
                            ->keyLabel('Key')
                            ->valueLabel('Value')
                            ->helperText('Additional data to send with the notification'),
                    ])->columns(1),

                Forms\Components\Section::make('Recipients')
                    ->schema([
                        Forms\Components\Select::make('user_ids')
                            ->label('Select Users')
                            ->multiple()
                            ->required()
                            ->searchable()
                            ->getSearchResultsUsing(function (string $search): array {
                                return User::query()
                                    // ->whereHas('devices', function ($query) {
                                    //     $query->whereNotNull('fcm_token');
                                    // })
                                    ->where(function ($query) use ($search) {
                                        $query->where('email', 'like', "%{$search}%")
                                            ->orWhere('name', 'like', "%{$search}%");
                                    })
                                    ->with(['preference', 'devices' => function($query) {
                                        $query->whereNotNull('fcm_token');
                                    }])
                                    ->limit(50)
                                    ->get()
                                    ->mapWithKeys(function (User $user) {
                                        $deviceCount = $user->devices->count();
                                        $notificationsEnabled = $user->preference?->notifications_are_enabled ?? true;
                                        $status = $notificationsEnabled ? '✅' : '❌';
                                        $name = $user->name ? " ({$user->name})" : '';

                                        return [
                                            $user->id => "{$status} {$user->email}{$name} - {$deviceCount} devices"
                                        ];
                                    })
                                    ->toArray();
                            })
                            ->getOptionLabelsUsing(function (array $values): array {
                                return User::whereIn('id', $values)
                                    // ->with(['preference', 'devices' => function($query) {
                                    //     $query->whereNotNull('fcm_token');
                                    // }])
                                    ->get()
                                    ->mapWithKeys(function (User $user) {
                                        $deviceCount = $user->devices->count();
                                        $notificationsEnabled = $user->preference?->notifications_are_enabled ?? true;
                                        $status = $notificationsEnabled ? '✅' : '❌';
                                        $name = $user->name ? " ({$user->name})" : '';

                                        return [
                                            $user->id => "{$status} {$user->email}{$name} - {$deviceCount} devices"
                                        ];
                                    })
                                    ->toArray();
                            })
                            ->placeholder('Search users by email or name...')
                            ->helperText('✅ = Notifications enabled, ❌ = Notifications disabled. Type to search users.'),
                    ])->columns(1),
            ])
            ->statePath('data');
    }

    protected function getFormActions(): array
    {
        return [
            Action::make('send')
                ->label('Send Notification')
                ->color('primary')
                ->icon('heroicon-o-paper-airplane')
                ->requiresConfirmation()
                ->modalHeading('Send Notification')
                ->modalDescription('Are you sure you want to send this notification to the selected users?')
                ->modalSubmitActionLabel('Send Now')
                ->action('sendNotification'),

            Action::make('preview')
                ->label('Preview')
                ->color('gray')
                ->icon('heroicon-o-eye')
                ->action('previewNotification'),
        ];
    }

    public function sendNotification(): void
    {
        $data = $this->form->getState();

        if (empty($data['user_ids'])) {
            Notification::make()
                ->title('No Recipients Selected')
                ->body('Please select at least one user to send the notification to.')
                ->danger()
                ->send();
            return;
        }

        try {
            $messagingRepository = app(MessagingRepositoryInterface::class);

            $result = $messagingRepository->sendNotificationToUsers(
                title: $data['title'],
                body: $data['body'],
                userIds: $data['user_ids'],
                data: $data['data'] ?? []
            );

            $successMessage = sprintf(
                'Notification sent successfully! Batch ID: %s - %d devices targeted, %d successful, %d failed (%.1f%% success rate)',
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

            // Clear form after successful send
            $this->form->fill([
                'title' => '',
                'body' => '',
                'data' => [],
                'user_ids' => [],
            ]);

            Log::info('Notification sent via Filament admin', [
                'batch_id' => $result['batch_id'],
                'admin_user' => auth()->user()->email,
                'title' => $data['title'],
                'total_devices' => $result['total_devices'],
                'success_rate' => $result['success_rate'],
            ]);

        } catch (\Exception $e) {
            Notification::make()
                ->title('Failed to Send Notification')
                ->body('Error: ' . $e->getMessage())
                ->danger()
                ->send();

            Log::error('Failed to send notification via Filament admin', [
                'error' => $e->getMessage(),
                'admin_user' => auth()->user()->email,
                'title' => $data['title'] ?? 'Unknown',
            ]);
        }
    }

    public function previewNotification(): void
    {
        $data = $this->form->getState();

        $userCount = count($data['user_ids'] ?? []);
        $deviceCount = User::whereIn('id', $data['user_ids'] ?? [])
            ->withCount(['devices' => function($query) {
                $query->whereNotNull('fcm_token');
            }])
            ->get()
            ->sum('devices_count');

        $previewMessage = sprintf(
            "Title: %s\n\nBody: %s\n\nRecipients: %d users (%d devices)\n\nCustom Data: %s",
            $data['title'] ?? '[No title]',
            $data['body'] ?? '[No body]',
            $userCount,
            $deviceCount,
            empty($data['data']) ? 'None' : json_encode($data['data'], JSON_PRETTY_PRINT)
        );

        Notification::make()
            ->title('Notification Preview')
            ->body($previewMessage)
            ->info()
            ->duration(15000)
            ->send();
    }
}
