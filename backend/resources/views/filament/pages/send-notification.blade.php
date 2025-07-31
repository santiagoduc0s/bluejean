<x-filament-panels::page>
    <x-filament::section>
        <x-slot name="heading">
            Send Firebase Notification
        </x-slot>
        
        <x-slot name="description">
            Compose and send push notifications to selected users. All their devices will receive the notification.
        </x-slot>

        {{ $this->form }}
        
        <div class="mt-6 flex gap-3">
            @foreach($this->getFormActions() as $action)
                {{ $action }}
            @endforeach
        </div>
    </x-filament::section>
</x-filament-panels::page>