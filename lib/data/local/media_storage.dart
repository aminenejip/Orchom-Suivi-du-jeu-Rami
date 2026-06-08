import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class MediaStorage {
  Future<String> saveImageFile(XFile xFile) async {
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(dir.path, 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    // Always save as .jpg after conversion
    final destPath = p.join(imagesDir.path, '$timestamp.jpg');

    debugPrint('[MediaStorage] XFile.name: ${xFile.name}');
    debugPrint('[MediaStorage] XFile.path: ${xFile.path}');
    debugPrint('[MediaStorage] destPath: $destPath');

    final bytes = await xFile.readAsBytes();
    debugPrint('[MediaStorage] bytes length: ${bytes.length}');

    if (bytes.isEmpty) {
      throw Exception('Image bytes are empty — cannot save file');
    }

    // Convert to JPEG for cross-platform compatibility
    final jpegBytes = await _convertToJpeg(bytes);

    await File(destPath).writeAsBytes(jpegBytes);

    final savedFile = File(destPath);
    debugPrint('[MediaStorage] File.exists: ${await savedFile.exists()}');
    debugPrint('[MediaStorage] File.length: ${await savedFile.length()}');

    final normalizedPath = destPath.replaceAll('\\', '/');
    debugPrint('[MediaStorage] normalizedPath: $normalizedPath');
    return normalizedPath;
  }

  Future<Uint8List> _convertToJpeg(Uint8List bytes) async {
    // Try flutter_image_compress first (handles HEIC on Android/iOS)
    final compressed = await FlutterImageCompress.compressWithList(
      bytes,
      format: CompressFormat.jpeg,
      quality: 90,
    );
    if (compressed.isNotEmpty) {
      debugPrint('[MediaStorage] Converted to JPEG via flutter_image_compress');
      debugPrint(
          '[MediaStorage] Original size: ${bytes.length}, JPEG size: ${compressed.length}');
      return compressed;
    }

    // Fallback: pure Dart image decoder (handles WebP, TIFF, etc. on desktop)
    final decoded = img.decodeImage(bytes);
    if (decoded != null) {
      final jpeg = img.encodeJpg(decoded);
      debugPrint('[MediaStorage] Converted to JPEG via image package');
      debugPrint(
          '[MediaStorage] Original size: ${bytes.length}, JPEG size: ${jpeg.length}');
      return Uint8List.fromList(jpeg);
    }

    throw FormatException(
      'Impossible de décoder cette image. '
      'Formats supportés : JPEG, PNG, WebP, HEIC (Android/iOS).',
    );
  }
}
