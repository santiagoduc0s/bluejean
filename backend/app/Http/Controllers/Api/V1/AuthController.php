<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\Company;
use App\Models\User;
use App\Models\UserProvider;
use App\Services\AppleAuthService;
use App\Services\GoogleAuthService;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Auth\Notifications\VerifyEmail;
use Illuminate\Support\Facades\Password;

class AuthController extends Controller
{
    public function __construct(
        private AppleAuthService $appleAuthService,
        private GoogleAuthService $googleAuthService
    ) {
    }

    public function signUp(Request $request)
    {
        $request->validate([
            'email' => 'required|email|unique:user_providers,provider_id',
            'password' => 'required|min:8',
        ]);

        $user = User::create([
            'email' => $request->input('email'),
        ]);

        UserProvider::create([
            'user_id' => $user->id,
            'provider' => 'email',
            'provider_id' => $request->input('email'),
            'provider_email' => $request->input('email'),
            'password' => $request->input('password'),
        ]);

        $this->createUserCompany($user);

        event(new Registered($user));

        return response()->json([], status: 204);
    }

    public function signIn(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $provider = UserProvider::byEmail($request->input('email'))->first();

        if (!$provider || !$provider->checkPassword($request->input('password'))) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

        $user = $provider->user;

        if (!$user->hasVerifiedEmail()) {
            throw ValidationException::withMessages([
                'email' => ['Your email address is not verified. Please check your email for verification link.'],
            ]);
        }

        $token = $user->createToken('auth_token')->plainTextToken;
        return response()->json(['token' => $token]);
    }

    public function signOut(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json([], status: 204);
    }

    public function currentUser(Request $request)
    {
        return UserResource::make($request->user());
    }

    public function update(Request $request)
    {
        $request->validate([
            'name' => 'nullable|string|max:255',
            'photo' => 'nullable|string|max:255',
            'email' => 'nullable|email|max:255',
        ]);

        $user = $request->user();

        $user->update($request->only(['name', 'photo']));

        return UserResource::make($user);
    }

    public function verifyEmail(Request $request, $id, $hash)
    {
        $user = User::with('emailProvider')->findOrFail($id);

        $isInvalid = !hash_equals(
            known_string: (string) $hash,
            user_string: sha1($user->getEmailForVerification())
        );

        if ($isInvalid) {
            abort(400, 'Invalid verification link');
        }

        if (!$user->hasVerifiedEmail()) {
            $user->markEmailAsVerified();
        }

        return view('mails.email-verified');
    }

    public function resendVerificationEmail(Request $request)
    {
        $user = $request->user();

        if ($user->hasVerifiedEmail()) {
            return response()->json(['message' => 'Email already verified'], 400);
        }

        $user->notify(new VerifyEmail);

        return response()->json(['message' => 'Verification email sent'], 200);
    }

    public function signInWithProvider(Request $request)
    {
        $request->validate([
            'provider' => 'required|string|in:google,apple',
            'id_token' => 'required|string',
        ]);

        $provider = $request->input('provider');

        switch ($provider) {
            case 'google':
                return $this->handleGoogleSignIn($request);
            case 'apple':
                return $this->handleAppleSignIn($request);
            default:
                throw ValidationException::withMessages([
                    'provider' => ['Unsupported provider.'],
                ]);
        }
    }

    private function handleGoogleSignIn(Request $request)
    {

        $idToken = $request->input('id_token');

        $tokenData = $this->googleAuthService->verifyGoogleIdToken($idToken);

        $userData = $this->googleAuthService->extractUserDataFromToken($tokenData);

        $googleId = $userData['google_id'];
        $email = $userData['email'];

        $existingProvider = UserProvider::byProvider('google', $googleId)->first();
        $isNewUser = false;

        if ($existingProvider) {
            $user = $existingProvider->user;
        } else {
            $emailProvider = UserProvider::where('provider_email', $email)->first();

            if ($emailProvider) {
                $user = $emailProvider->user;
            } else {
                $user = User::create([
                    'email' => $email,
                ]);
                $isNewUser = true;
            }

            UserProvider::create([
                'user_id' => $user->id,
                'provider' => 'google',
                'provider_id' => $googleId,
                'provider_email' => $email,
                'email_verified_at' => now(),
            ]);

            if ($isNewUser) {
                $this->createUserCompany($user);
            }
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json(['token' => $token]);
    }

    private function handleAppleSignIn(Request $request)
    {
        $idToken = $request->input('id_token');

        $decoded = $this->appleAuthService->verifyAppleIdToken($idToken);

        $userData = $this->appleAuthService->extractUserDataFromToken($decoded);

        $appleId = $userData['apple_id'];
        $email = $userData['email'];

        $existingProvider = UserProvider::byProvider('apple', $appleId)->first();
        $isNewUser = false;

        if ($existingProvider) {
            $user = $existingProvider->user;
        } else {
            $emailProvider = UserProvider::where('provider_email', $email)->first();

            if ($emailProvider) {
                $user = $emailProvider->user;
            } else {
                $user = User::create([
                    'email' => $email,
                ]);
                $isNewUser = true;
            }

            UserProvider::create([
                'user_id' => $user->id,
                'provider' => 'apple',
                'provider_id' => $appleId,
                'provider_email' => $email,
                'email_verified_at' => $email ? now() : null,
            ]);

            if ($isNewUser) {
                $this->createUserCompany($user);
            }
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json(['token' => $token]);
    }

    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $email = $request->input('email');

        $provider = UserProvider::where('provider_email', $email)
            ->where('provider', 'email')
            ->first();

        if ($provider) {
            $user = $provider->user;
            Password::sendResetLink(['email' => $user->email]);
        }

        return response()->noContent();
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'token' => 'required',
            'email' => 'required|email',
            'password' => 'required|min:8|confirmed',
        ]);

        $status = Password::reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function (User $user, string $password) {
                $provider = $user->emailProvider;
                if ($provider) {
                    $provider->update(['password' => $password]);
                }
            }
        );

        if ($status === Password::PASSWORD_RESET) {
            return view('mails.password-reset-success');
        }

        return back()->with('status', __($status));
    }

    public function deleteAccount(Request $request)
    {
        $user = $request->user();
        $user->devices()->update([
            'user_id' => null,
            'personal_access_tokens_id' => null,
            'fcm_token' => null,
        ]);
        $user->tokens()->delete();
        $user->delete();
        return response()->json([], 204);
    }

    private function createUserCompany(User $user): void
    {
        $existingCompany = Company::where('name', "company-{$user->id}")->first();

        if (!$existingCompany) {
            $company = Company::create([
                'name' => "company-{$user->id}",
            ]);


            $user->companies()->attach($company->id, [
                'roles' => json_encode(['admin'])
            ]);
        }
    }
}
