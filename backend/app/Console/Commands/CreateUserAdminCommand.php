<?php

namespace App\Console\Commands;

use App\Models\UserAdmin;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class CreateUserAdminCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'user-admin:create 
                            {--name= : The admin user name}
                            {--email= : The admin user email}
                            {--password= : The admin user password}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Create a new admin user for Filament admin panel';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Creating a new admin user...');

        $name = $this->option('name') ?: $this->ask('What is the admin name?');
        $email = $this->option('email') ?: $this->ask('What is the admin email?');
        $password = $this->option('password') ?: $this->secret('What is the admin password?');

        $validator = Validator::make([
            'name' => $name,
            'email' => $email,
            'password' => $password,
        ], [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:user_admins'],
            'password' => ['required', 'string', 'min:8'],
        ]);

        if ($validator->fails()) {
            $this->error('Validation failed:');
            foreach ($validator->errors()->all() as $error) {
                $this->error('- ' . $error);
            }
            return Command::FAILURE;
        }

        try {
            $userAdmin = UserAdmin::create([
                'name' => $name,
                'email' => $email,
                'password' => Hash::make($password),
            ]);

            $this->info("Admin user created successfully!");
            $this->table(
                ['ID', 'Name', 'Email', 'Created At'],
                [[$userAdmin->id, $userAdmin->name, $userAdmin->email, $userAdmin->created_at]]
            );

            return Command::SUCCESS;
        } catch (\Exception $e) {
            $this->error('Failed to create admin user: ' . $e->getMessage());
            return Command::FAILURE;
        }
    }
}
