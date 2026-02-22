<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use Illuminate\Auth\Notifications\VerifyEmail;
use Illuminate\Support\Facades\Password;

class AuthController extends Controller
{
    public function signUp(Request $request)
    {
        $request->validate([
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:8',
        ]);

        $user = User::create([
            'email' => $request->input('email'),
            'password' => $request->input('password'),
        ]);

        event(new Registered($user));

        return response()->json([], status: 204);
    }

    public function signIn(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->input('email'))->first();

        if (!$user || !Hash::check($request->input('password'), $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

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
        $user = User::findOrFail($id);

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

    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $user = User::where('email', $request->input('email'))->first();

        if ($user) {
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
                $user->update(['password' => $password]);
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
}
