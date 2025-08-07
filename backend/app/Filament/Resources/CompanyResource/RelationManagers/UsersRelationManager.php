<?php

namespace App\Filament\Resources\CompanyResource\RelationManagers;

use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class UsersRelationManager extends RelationManager
{
    protected static string $relationship = 'users';

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('roles')
                    ->label('Roles')
                    ->multiple()
                    ->options([
                        'admin' => 'Admin',
                        'member' => 'Member',
                    ])
                    ->default(['member'])
                    ->required()
                    ->helperText('Select one or more roles for this user in the company'),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('name')
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->label('User Name')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('email')
                    ->label('Email')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('pivot.roles')
                    ->label('Roles')
                    ->badge()
                    ->formatStateUsing(function ($state) {
                        if (is_string($state)) {
                            $roles = json_decode($state, true);
                        } else {
                            $roles = $state;
                        }
                        return is_array($roles) ? implode(', ', $roles) : ($roles ?: 'No roles');
                    })
                    ->color(fn ($state) => str_contains($state, 'admin') ? 'warning' : 'success'),
                Tables\Columns\TextColumn::make('pivot.created_at')
                    ->label('Added')
                    ->dateTime()
                    ->sortable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('roles')
                    ->label('Role')
                    ->options([
                        'admin' => 'Admin',
                        'member' => 'Member',
                    ])
                    ->query(function (Builder $query, array $data): Builder {
                        if (filled($data['value'])) {
                            return $query->whereRaw('JSON_CONTAINS(company_user.roles, ?)', ['"' . $data['value'] . '"']);
                        }
                        return $query;
                    }),
            ])
            ->headerActions([
                Tables\Actions\AttachAction::make()
                    ->form(fn (Tables\Actions\AttachAction $action): array => [
                        $action->getRecordSelect(),
                        Forms\Components\Select::make('roles')
                            ->label('Roles')
                            ->multiple()
                            ->options([
                                'admin' => 'Admin',
                                'member' => 'Member',
                            ])
                            ->default(['member'])
                            ->required()
                            ->helperText('Select one or more roles for this user in the company'),
                    ]),
            ])
            ->actions([
                Tables\Actions\EditAction::make()
                    ->form([
                        Forms\Components\Select::make('roles')
                            ->label('Roles')
                            ->multiple()
                            ->options([
                                'admin' => 'Admin',
                                'member' => 'Member',
                            ])
                            ->required()
                            ->helperText('Select one or more roles for this user in the company'),
                    ]),
                Tables\Actions\DetachAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DetachBulkAction::make(),
                ]),
            ]);
    }
}
