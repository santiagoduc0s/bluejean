import { Head, Link, useForm, usePage } from '@inertiajs/react';
import AppLayout from '../../Layouts/AppLayout';

export default function ForgotPassword() {
    const { flash } = usePage().props;
    const { data, setData, post, processing, errors } = useForm({
        email: '',
    });

    function handleSubmit(e) {
        e.preventDefault();
        post('/forgot-password');
    }

    return (
        <AppLayout>
            <Head title="Forgot password" />
            <div className="max-w-md mx-auto px-4 py-16">
                <h1 className="text-2xl font-bold text-gray-900 text-center mb-4">Forgot password</h1>
                <p className="text-sm text-gray-600 text-center mb-8">
                    Enter your email and we'll send you a link to reset your password.
                </p>
                {flash.status && (
                    <div className="mb-4 text-sm text-green-600 bg-green-50 border border-green-200 rounded-md px-4 py-3">
                        {flash.status}
                    </div>
                )}
                <form onSubmit={handleSubmit} className="space-y-4">
                    <div>
                        <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-1">
                            Email
                        </label>
                        <input
                            id="email"
                            type="email"
                            value={data.email}
                            onChange={(e) => setData('email', e.target.value)}
                            className="w-full border border-gray-300 rounded-md px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-gray-900 focus:border-transparent"
                            required
                        />
                        {errors.email && <p className="mt-1 text-sm text-red-600">{errors.email}</p>}
                    </div>
                    <button
                        type="submit"
                        disabled={processing}
                        className="w-full bg-gray-900 text-white py-2 px-4 rounded-md text-sm font-medium hover:bg-gray-800 disabled:opacity-50"
                    >
                        Send reset link
                    </button>
                    <p className="text-center text-sm text-gray-600">
                        <Link href="/login" className="text-gray-900 font-medium hover:underline">
                            Back to login
                        </Link>
                    </p>
                </form>
            </div>
        </AppLayout>
    );
}
