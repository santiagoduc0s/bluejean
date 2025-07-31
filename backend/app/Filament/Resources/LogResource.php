<?php

namespace App\Filament\Resources;

use App\Filament\Resources\LogResource\Pages;
use App\Filament\Resources\LogResource\RelationManagers;
use App\Models\Log;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Infolists;
use Filament\Infolists\Infolist;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class LogResource extends Resource
{
    protected static ?string $model = Log::class;

    protected static ?string $navigationIcon = 'heroicon-o-exclamation-triangle';
    
    protected static ?string $navigationLabel = 'Application Logs';
    
    protected static ?string $modelLabel = 'Log Entry';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('message')
                    ->disabled(),
                Forms\Components\Select::make('type')
                    ->options([
                        'info' => 'Info',
                        'warning' => 'Warning', 
                        'error' => 'Error',
                        'debug' => 'Debug',
                        'critical' => 'Critical',
                    ])
                    ->disabled(),
                Forms\Components\Textarea::make('stack_trace')
                    ->label('Stack Trace')
                    ->rows(8)
                    ->disabled(),
                Forms\Components\KeyValue::make('metadata')
                    ->disabled(),
            ]);
    }

    public static function infolist(Infolist $infolist): Infolist
    {
        return $infolist
            ->schema([
                Infolists\Components\Section::make('Log Details')
                    ->schema([
                        Infolists\Components\TextEntry::make('type')
                            ->badge()
                            ->color(fn (string $state): string => match ($state) {
                                'info' => 'info',
                                'warning' => 'warning',
                                'error' => 'danger',
                                'critical' => 'danger',
                                'debug' => 'gray',
                                default => 'gray',
                            }),
                        Infolists\Components\TextEntry::make('message')
                            ->prose(),
                        Infolists\Components\TextEntry::make('created_at')
                            ->label('Logged At')
                            ->dateTime(),
                    ])->columns(3),
                
                Infolists\Components\Section::make('Stack Trace')
                    ->schema([
                        Infolists\Components\TextEntry::make('stack_trace')
                            ->prose()
                            ->markdown(),
                    ])
                    ->visible(fn ($record) => !empty($record->stack_trace)),
                    
                Infolists\Components\Section::make('Metadata')
                    ->schema([
                        Infolists\Components\KeyValueEntry::make('metadata'),
                    ])
                    ->visible(fn ($record) => !empty($record->metadata)),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id')
                    ->label('ID')
                    ->sortable(),
                Tables\Columns\TextColumn::make('type')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'info' => 'info',
                        'warning' => 'warning',
                        'error' => 'danger',
                        'critical' => 'danger',
                        'debug' => 'gray',
                        default => 'gray',
                    })
                    ->sortable(),
                Tables\Columns\TextColumn::make('message')
                    ->searchable()
                    ->limit(80)
                    ->tooltip(function ($record) {
                        return $record->message;
                    }),
                Tables\Columns\IconColumn::make('stack_trace')
                    ->label('Stack Trace')
                    ->boolean()
                    ->trueIcon('heroicon-o-exclamation-triangle')
                    ->falseIcon('heroicon-o-minus')
                    ->state(fn ($record) => !empty($record->stack_trace)),
                Tables\Columns\IconColumn::make('metadata')
                    ->label('Metadata')
                    ->boolean()
                    ->trueIcon('heroicon-o-document-text')
                    ->falseIcon('heroicon-o-minus')
                    ->state(fn ($record) => !empty($record->metadata)),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Logged At')
                    ->dateTime()
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->filters([
                Tables\Filters\SelectFilter::make('type')
                    ->options([
                        'info' => 'Info',
                        'warning' => 'Warning',
                        'error' => 'Error',
                        'debug' => 'Debug',
                        'critical' => 'Critical',
                    ]),
                Tables\Filters\Filter::make('created_at')
                    ->form([
                        Forms\Components\DatePicker::make('created_from')
                            ->label('From Date'),
                        Forms\Components\DatePicker::make('created_until')
                            ->label('Until Date'),
                    ])
                    ->query(function (Builder $query, array $data): Builder {
                        return $query
                            ->when(
                                $data['created_from'],
                                fn (Builder $query, $date): Builder => $query->whereDate('created_at', '>=', $date),
                            )
                            ->when(
                                $data['created_until'],
                                fn (Builder $query, $date): Builder => $query->whereDate('created_at', '<=', $date),
                            );
                    })
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
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
            'index' => Pages\ListLogs::route('/'),
            // 'create' => Pages\CreateLog::route('/create'),
            // 'edit' => Pages\EditLog::route('/{record}/edit'),
        ];
    }
}
