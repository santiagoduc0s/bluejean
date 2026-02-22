<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class FileController extends Controller
{
    public function upload(Request $request)
    {
        $request->validate([
            'file' => 'required|file|max:10240',
            'path' => 'required|string|max:255',
        ]);

        $allowedPaths = ['profile'];

        if (!in_array(trim($request->input('path'), '/'), $allowedPaths)) {
            throw ValidationException::withMessages([
                'path' => 'Invalid path. Only profile uploads are allowed.',
            ]);
        }

        $path = $this->sanitizePath($request->input('path'));
        $file = $request->file('file');

        if (!$file || !$file->isValid()) {
            return response()->json([
                'error' => 'Invalid file upload'
            ], 422);
        }

        $mimeType = $file->getMimeType();
        $extension = $this->getExtensionFromMimeType($mimeType);

        $filename = time() . '_' . Str::random(10) . '.' . $extension;

        $storedPath = Storage::putFileAs($path, $file, $filename);

        Log::info("File uploaded to {$storedPath} with MIME type {$mimeType}");

        if (!$storedPath) {
            return response()->json([
                'error' => 'Failed to store file'
            ], 500);
        }

        $url = Storage::url($storedPath);

        return response()->json([
            'success' => true,
            'url' => $url,
            'path' => $storedPath,
            'filename' => $filename,
            'size' => $file->getSize(),
            'mime_type' => $mimeType
        ]);
    }

    private function sanitizePath(string $path): string
    {
        $path = trim($path, '/');
        $path = str_replace(['../', '..\\'], '', $path);
        $path = preg_replace('/[^a-zA-Z0-9\/_-]/', '_', $path);

        return $path ?: 'uploads';
    }

    private function getExtensionFromMimeType(string $mimeType): string
    {
        $mimeToExtension = [
            // Images
            'image/jpeg' => 'jpg',
            'image/jpg' => 'jpg',
            'image/png' => 'png',
            'image/gif' => 'gif',
            'image/webp' => 'webp',
            'image/svg+xml' => 'svg',
            'image/bmp' => 'bmp',
            'image/tiff' => 'tiff',
            'image/ico' => 'ico',

            // Documents
            'application/pdf' => 'pdf',
            'application/msword' => 'doc',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'docx',
            'application/vnd.ms-excel' => 'xls',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => 'xlsx',
            'application/vnd.ms-powerpoint' => 'ppt',
            'application/vnd.openxmlformats-officedocument.presentationml.presentation' => 'pptx',
            'text/plain' => 'txt',
            'text/csv' => 'csv',
            'application/rtf' => 'rtf',

            // Archives
            'application/zip' => 'zip',
            'application/x-rar-compressed' => 'rar',
            'application/x-7z-compressed' => '7z',
            'application/x-tar' => 'tar',
            'application/gzip' => 'gz',

            // Audio
            'audio/mpeg' => 'mp3',
            'audio/wav' => 'wav',
            'audio/ogg' => 'ogg',
            'audio/aac' => 'aac',
            'audio/flac' => 'flac',

            // Video
            'video/mp4' => 'mp4',
            'video/avi' => 'avi',
            'video/quicktime' => 'mov',
            'video/x-msvideo' => 'avi',
            'video/webm' => 'webm',
            'video/ogg' => 'ogv',
        ];

        return $mimeToExtension[$mimeType] ?? 'bin';
    }
}
