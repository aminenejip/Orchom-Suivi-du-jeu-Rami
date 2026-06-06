import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class MediaStorage {
  Future<String> saveImageFile(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final photoDir = Directory(p.join(dir.path, 'orchom_photos'));
    if (!await photoDir.exists()) {
      await photoDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ext = p.extension(sourcePath);
    final destPath = p.join(photoDir.path, '$timestamp$ext');

    await File(sourcePath).copy(destPath);
    return destPath;
  }
}
