// Dart imports:
import 'dart:io';

// Package imports:
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PathScript {
  static Future<String> newTempRecordingPath() async {
    final dir = await getTemporaryDirectory();
    final name = 'rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
    return p.join(dir.path, name);
  }

  static Future<String> commitRecordingToLibrary(String tempPath) async {
    final docs = await getApplicationSupportDirectory();
    final libraryDir = Directory(p.join(docs.path, 'recordings'));
    await libraryDir.create(recursive: true);

    final finalName = 'rec_${DateTime.now().millisecondsSinceEpoch}.wav';
    final finalPath = p.join(libraryDir.path, finalName);

    await File(tempPath).rename(finalPath);
    return finalPath;
  }
}
