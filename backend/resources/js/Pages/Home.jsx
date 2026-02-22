import { Head } from "@inertiajs/react";
import AppLayout from "../Layouts/AppLayout";

export default function Home() {
    return (
        <AppLayout>
            <Head title="Bluejean" />
            <div className="max-w-4xl mx-auto px-4 py-16 sm:px-6 lg:px-8">
                <h1 className="text-4xl font-bold text-gray-900 text-center">
                    Welcome to Bluejean
                </h1>
            </div>
        </AppLayout>
    );
}
