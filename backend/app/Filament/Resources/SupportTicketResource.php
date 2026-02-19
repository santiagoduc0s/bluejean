<?php

namespace App\Filament\Resources;

use App\Filament\Resources\SupportTicketResource\Pages;
use App\Filament\Resources\SupportTicketResource\RelationManagers;
use App\Models\SupportTicket;
use Filament\Forms;
use Filament\Schemas\Schema;
use Filament\Infolists;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class SupportTicketResource extends Resource
{
    protected static ?string $model = SupportTicket::class;

    protected static string|\BackedEnum|null $navigationIcon = 'heroicon-o-chat-bubble-left-ellipsis';
    
    protected static ?string $navigationLabel = 'Support Tickets';
    
    protected static ?string $modelLabel = 'Support Ticket';

    public static function form(Schema $schema): Schema
    {
        return $schema
            ->schema([
                Forms\Components\TextInput::make('email')
                    ->email()
                    ->disabled(),
                Forms\Components\TextInput::make('title')
                    ->disabled(),
                Forms\Components\Textarea::make('description')
                    ->rows(5)
                    ->disabled(),
                Forms\Components\TagsInput::make('files')
                    ->label('Attached Files')
                    ->disabled(),
            ]);
    }

    public static function infolist(Schema $schema): Schema
    {
        return $schema
            ->schema([
                Infolists\Components\Section::make('Support Ticket Details')
                    ->schema([
                        Infolists\Components\TextEntry::make('email')
                            ->label('Email'),
                        Infolists\Components\TextEntry::make('title')
                            ->label('Title'),
                        Infolists\Components\TextEntry::make('description')
                            ->label('Description')
                            ->prose(),
                        Infolists\Components\TextEntry::make('created_at')
                            ->label('Submitted At')
                            ->dateTime(),
                    ])->columns(2),
                
                Infolists\Components\Section::make('Attached Files')
                    ->schema([
                        Infolists\Components\ImageEntry::make('files')
                            ->label('Images'),
                    ])
                    ->visible(fn ($record) => $record->files_count > 0),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id')
                    ->label('ID')
                    ->sortable(),
                Tables\Columns\TextColumn::make('email')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('title')
                    ->searchable()
                    ->sortable()
                    ->limit(50),
                Tables\Columns\TextColumn::make('description')
                    ->searchable()
                    ->limit(100)
                    ->tooltip(function ($record) {
                        return $record->description;
                    }),
                Tables\Columns\TextColumn::make('files_count')
                    ->label('Files')
                    ->formatStateUsing(function ($record) {
                        $count = $record->files_count;
                        if ($count === 0) return 'No files';
                        return "{$count} file" . ($count > 1 ? 's' : '');
                    })
                    ->badge()
                    ->color(fn($record) => $record->files_count > 0 ? 'success' : 'gray'),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->filters([
                Tables\Filters\Filter::make('created_at')
                    ->form([
                        Forms\Components\DatePicker::make('created_from'),
                        Forms\Components\DatePicker::make('created_until'),
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
            'index' => Pages\ListSupportTickets::route('/'),
            // 'create' => Pages\CreateSupportTicket::route('/create'),
            // 'edit' => Pages\EditSupportTicket::route('/{record}/edit'),
        ];
    }
}
