import 'package:flutter/foundation.dart' show debugPrint;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'save_file_mobile.dart'
    if (dart.library.js_interop) 'save_file_web.dart';

/// Service for downloading PDF files across different platforms
/// Enhanced with detailed error handling (Sub-task 8.2)
class PdfDownloadService {
  /// Sanitizes filename to prevent path traversal and invalid characters
  static String _sanitizeFilename(String filename) {
    // Remove path separators and invalid characters
    String sanitized =
        filename.replaceAll(RegExp(r'[/\\:*?"<>|]'), '_').replaceAll('..', '_');

    // Ensure .pdf extension
    if (!sanitized.toLowerCase().endsWith('.pdf')) {
      sanitized = '$sanitized.pdf';
    }

    // Limit filename length
    if (sanitized.length > 255) {
      final extension = '.pdf';
      final maxNameLength = 255 - extension.length;
      sanitized = '${sanitized.substring(0, maxNameLength)}$extension';
    }

    return sanitized;
  }

  /// Downloads PDF from PdfViewerController
  ///
  /// This method saves the PDF document with any annotations or modifications
  /// made in the viewer. Works on both web and Android platforms.
  ///
  /// - Web: Triggers browser download
  /// - Android: Saves to external storage directory
  ///
  /// Throws:
  /// - [PdfDownloadException] for download errors (wraps platform-specific exceptions)
  static Future<void> downloadFromController(
    PdfViewerController controller,
    String filename,
  ) async {
    final sanitizedFilename = _sanitizeFilename(filename);

    try {
      debugPrint('Starting PDF download: $sanitizedFilename');

      // Get the PDF bytes from the controller (includes annotations)
      final List<int> bytes = await controller.saveDocument();

      debugPrint('PDF document saved: ${bytes.length} bytes');

      // Use the helper to save the file
      await FileSaveHelper.saveAndLaunchFile(
        bytes,
        sanitizedFilename,
      );

      debugPrint('PDF download completed: $sanitizedFilename');
    } catch (e) {
      debugPrint('PDF download failed: ${e.toString()}');
      // Re-throw the original exception to preserve type information
      rethrow;
    }
  }

  /// Downloads PDF from raw bytes
  ///
  /// Use this when you have PDF data but not from a PdfViewerController
  ///
  /// Throws:
  /// - Platform-specific exceptions (PermissionDeniedException, FileWriteException, etc.)
  static Future<void> downloadFromBytes(
    List<int> bytes,
    String filename,
  ) async {
    final sanitizedFilename = _sanitizeFilename(filename);

    try {
      debugPrint('Starting PDF download from bytes: $sanitizedFilename');

      await FileSaveHelper.saveAndLaunchFile(
        bytes,
        sanitizedFilename,
      );

      debugPrint('PDF download completed: $sanitizedFilename');
    } catch (e) {
      debugPrint('PDF download failed: ${e.toString()}');
      // Re-throw the original exception to preserve type information
      rethrow;
    }
  }
}

/// Exception thrown when PDF download fails
class PdfDownloadException implements Exception {
  final String message;
  PdfDownloadException(this.message);

  @override
  String toString() => message;
}
