<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('listener_notifications', function (Blueprint $table) {
            $table->foreignId('driver_position_id')->nullable()->after('listener_id')->constrained('driver_positions')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('listener_notifications', function (Blueprint $table) {
            $table->dropForeign(['driver_position_id']);
            $table->dropColumn('driver_position_id');
        });
    }
};
