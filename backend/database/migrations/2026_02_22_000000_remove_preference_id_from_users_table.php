<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign(['preference_id']);
            $table->dropUnique(['preference_id']);
            $table->dropColumn('preference_id');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('preference_id')
                ->after('id')
                ->nullable()
                ->constrained('preferences')
                ->onDelete('set null');
            $table->unique('preference_id');
        });
    }
};
