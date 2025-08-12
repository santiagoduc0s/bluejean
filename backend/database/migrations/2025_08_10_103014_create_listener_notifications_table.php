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
        Schema::create('listener_notifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('listener_id')->constrained('listeners')->onDelete('cascade');
            $table->string('type')->default('go-outside'); // Could be 'go-outside', 'enter-zone', etc.
            $table->string('title')->nullable();
            $table->text('body')->nullable();
            $table->timestamps();
            
            // Add index for performance when checking last notification
            $table->index(['listener_id', 'created_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('listener_notifications');
    }
};
