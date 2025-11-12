import 'dart:io';

/// Package imports
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:path_provider/path_provider.dart';

// ignore: avoid_classes_with_only_static_members
/// To save the pdf file in the device
class FileSaveHelper {
  /// To save the pdf file in the device (Android only)
  /// Enhanced with permission handling (Sub-task 8.2)
  ///
  /// Saves files to the Downloads directory for easy access
  /// Files are stored in: /storage/emulated/0/Download/
  static Future<void> saveAndLaunchFile(
    List<int> bytes,
    String fileName,
  ) async {
    String? path;

    if (Platform.isAndroid) {
      debugPrint('Saving PDF file to Downloads on Android');

      // Use Downloads directory - accessible to user via file manager
      // Path: /storage/emulated/0/Download/
      final Directory directory = Directory('/storage/emulated/0/Download');

      if (directory.existsSync()) {
        path = directory.path;
        debugPrint('Using Downloads directory: $path');
      } else {
        // Fallback to app-specific directory if Downloads not available
        debugPrint(
            'Downloads directory not available, using app-specific directory');
        final Directory? appDirectory = await getExternalStorageDirectory();
        if (appDirectory != null) {
          path = appDirectory.path;
          debugPrint('Using external storage directory: $path');
        } else {
          final Directory directory = await getApplicationSupportDirectory();
          path = directory.path;
          debugPrint('Using application support directory: $path');
        }
      }
    } else {
      // Fallback for other platforms (though app is Android/Web only)
      final Directory directory = await getApplicationSupportDirectory();
      path = directory.path;
    }

    try {
      final File file = File('$path/$fileName');
      debugPrint('Saving file to: ${file.path}');
      await file.writeAsBytes(bytes, flush: true);
      debugPrint('File saved successfully: ${file.path}');
      debugPrint('You can find the file in Downloads folder: $fileName');
    } on FileSystemException catch (e) {
      debugPrint('File write error: ${e.message}');
      throw FileWriteException(
        'No se pudo guardar el archivo: ${e.message}',
      );
    }
  }
}

/// Exception thrown when file write fails
class FileWriteException implements Exception {
  final String message;
  FileWriteException(this.message);

  @override
  String toString() => message;
}
