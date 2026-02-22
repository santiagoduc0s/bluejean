import { Link, usePage } from '@inertiajs/react';

export default function AppLayout({ children }) {
    const { auth } = usePage().props;

    return (
        <div className="min-h-screen bg-gray-50">
            <nav className="bg-white border-b border-gray-200">
                <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div className="flex justify-between h-14 items-center">
                        <Link href="/" className="text-lg font-semibold text-gray-900">
                            Bluejean
                        </Link>
                        <div className="flex items-center gap-4">
                            {auth.user ? (
                                <>
                                    <span className="text-sm text-gray-600">{auth.user.email}</span>
                                    <Link
                                        href="/logout"
                                        method="post"
                                        as="button"
                                        className="text-sm text-gray-600 hover:text-gray-900"
                                    >
                                        Log out
                                    </Link>
                                </>
                            ) : (
                                <>
                                    <Link href="/login" className="text-sm text-gray-600 hover:text-gray-900">
                                        Log in
                                    </Link>
                                    <Link
                                        href="/register"
                                        className="text-sm bg-gray-900 text-white px-3 py-1.5 rounded-md hover:bg-gray-800"
                                    >
                                        Register
                                    </Link>
                                </>
                            )}
                        </div>
                    </div>
                </div>
            </nav>
            <main>{children}</main>
        </div>
    );
}
