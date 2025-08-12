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
        Schema::table('listeners', function (Blueprint $table) {
            $table->unsignedInteger('threshold_meters')->default(200)->after('longitude');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('listeners', function (Blueprint $table) {
            $table->dropColumn('threshold_meters');
        });
    }
};
