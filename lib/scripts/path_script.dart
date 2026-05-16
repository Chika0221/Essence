// Dart imports:
import 'dart:io';

// Package imports:
import 'package:filepicker_windows/filepicker_windows.dart';
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

  static String? pickFile() {
    final picker = OpenFilePicker()
      ..filterSpecification = {
        'Audio Files (*.wav; *.m4a; *.mp3; *.aac)': '*.wav;*.m4a;*.mp3;*.aac',
        'All Files': '*.*',
      }
      ..defaultFilterIndex = 0
      ..defaultExtension = 'wav'
      ..title = 'Select an audio file';

    final file = picker.getFile();
    if (file == null) {
      print('No file selected.');
      return null;
    }

    print('Selected file: ${file.path}');
    return file.path;
  }
}
