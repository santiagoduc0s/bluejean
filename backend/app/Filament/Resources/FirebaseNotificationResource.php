<?php

namespace App\Filament\Resources;

use App\Filament\Resources\FirebaseNotificationResource\Pages;
use App\Models\FirebaseNotification;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;

class FirebaseNotificationResource extends Resource
{
    protected static ?string $model = FirebaseNotification::class;

    protected static ?string $navigationIcon = 'heroicon-o-bell';
    
    protected static ?string $navigationLabel = 'Firebase Notifications';
    
    protected static ?string $modelLabel = 'Firebase Notification';
    
    protected static ?string $navigationGroup = 'Push Notifications';

    public static function form(Form $form): Form
    {
        return $form->schema([]);
    }

    public static function infolist(Infolist $infolist): Infolist
    {
        return $infolist
            ->schema([
                Infolists\Components\Section::make('Notification Details')
                    ->schema([
                        Infolists\Components\TextEntry::make('title')
                            ->label('Title'),
                        Infolists\Components\TextEntry::make('body')
                            ->label('Body')
                            ->prose(),
                        Infolists\Components\TextEntry::make('status')
                            ->badge()
                            ->color(fn (string $state): string => match ($state) {
                                'success' => 'success',
                                'error' => 'danger',
                                'pending' => 'gray',
                                default => 'gray',
                            }),
                        Infolists\Components\TextEntry::make('created_at')
                            ->label('Created At')
                            ->dateTime(),
                        Infolists\Components\TextEntry::make('sent_at')
                            ->label('Sent At')
                            ->dateTime()
                            ->placeholder('Not sent yet'),
                    ])->columns(2),

                Infolists\Components\Section::make('Batch Information')
                    ->schema([
                        Infolists\Components\TextEntry::make('batch_id')
                            ->label('Batch ID')
                            ->copyable(),
                        Infolists\Components\TextEntry::make('firebase_message_id')
                            ->label('Firebase Message ID')
                            ->copyable()
                            ->placeholder('Not available'),
                    ])->columns(2),

                Infolists\Components\Section::make('Target Information')
                    ->schema([
                        Infolists\Components\TextEntry::make('user.email')
                            ->label('User Email')
                            ->placeholder('Direct token send'),
                        Infolists\Components\TextEntry::make('device.model')
                            ->label('Device Model')
                            ->placeholder('Not available'),
                        Infolists\Components\TextEntry::make('fcm_token')
                            ->label('FCM Token')
                            ->copyable()
                            ->limit(50),
                    ])->columns(1),

                Infolists\Components\Section::make('Payload Data')
                    ->schema([
                        Infolists\Components\KeyValueEntry::make('data')
                            ->label('Custom Data'),
                    ])
                    ->visible(fn ($record) => !empty($record->data)),

                Infolists\Components\Section::make('Error Details')
                    ->schema([
                        Infolists\Components\TextEntry::make('error_message')
                            ->label('Error Message')
                            ->prose()
                            ->color('danger'),
                    ])
                    ->visible(fn ($record) => !empty($record->error_message)),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id')
                    ->label('ID')
                    ->sortable(),
                Tables\Columns\TextColumn::make('batch_id')
                    ->label('Batch')
                    ->limit(8)
                    ->tooltip(function ($record) {
                        return $record->batch_id;
                    })
                    ->sortable(),
                Tables\Columns\TextColumn::make('title')
                    ->searchable()
                    ->sortable()
                    ->limit(30),
                Tables\Columns\TextColumn::make('body')
                    ->searchable()
                    ->limit(50)
                    ->tooltip(function ($record) {
                        return $record->body;
                    }),
                Tables\Columns\TextColumn::make('user.email')
                    ->label('User')
                    ->searchable()
                    ->placeholder('Direct send')
                    ->limit(25),
                Tables\Columns\TextColumn::make('device.model')
                    ->label('Device')
                    ->placeholder('N/A')
                    ->limit(20),
                Tables\Columns\TextColumn::make('status')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'success' => 'success',
                        'error' => 'danger',
                        'pending' => 'gray',
                        default => 'gray',
                    })
                    ->sortable(),
                Tables\Columns\TextColumn::make('sent_at')
                    ->label('Sent At')
                    ->dateTime()
                    ->placeholder('Pending')
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Created At')
                    ->dateTime()
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->filters([
                Tables\Filters\SelectFilter::make('status')
                    ->options([
                        'pending' => 'Pending',
                        'success' => 'Success',
                        'error' => 'Error',
                    ]),
                Tables\Filters\Filter::make('sent_at')
                    ->form([
                        Forms\Components\DatePicker::make('sent_from')
                            ->label('Sent From'),
                        Forms\Components\DatePicker::make('sent_until')
                            ->label('Sent Until'),
                    ])
                    ->query(function (Builder $query, array $data): Builder {
                        return $query
                            ->when(
                                $data['sent_from'],
                                fn (Builder $query, $date): Builder => $query->whereDate('sent_at', '>=', $date),
                            )
                            ->when(
                                $data['sent_until'],
                                fn (Builder $query, $date): Builder => $query->whereDate('sent_at', '<=', $date),
                            );
                    }),
                Tables\Filters\Filter::make('has_user')
                    ->label('Has User')
                    ->query(fn (Builder $query): Builder => $query->whereNotNull('user_id')),
                Tables\Filters\Filter::make('direct_send')
                    ->label('Direct Send')
                    ->query(fn (Builder $query): Builder => $query->whereNull('user_id')),
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
            ])
            ->bulkActions([
                // No bulk actions for read-only
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListFirebaseNotifications::route('/'),
            'view' => Pages\ViewFirebaseNotification::route('/{record}'),
        ];
    }

    public static function canCreate(): bool
    {
        return false;
    }

    public static function canEdit($record): bool
    {
        return false;
    }

    public static function canDelete($record): bool
    {
        return false;
    }

    public static function canDeleteAny(): bool
    {
        return false;
    }
}