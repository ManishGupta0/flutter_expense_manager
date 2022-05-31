import 'dart:io';
import 'package:file_picker/file_picker.dart';

class IOUtils {
  static Future<List<String>> filePicker({
    String? dialogTitle,
    bool multiple = false,
    List<String> extensions = const [],
  }) async {
    var file = await FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
      allowMultiple: multiple,
      type: extensions.isEmpty ? FileType.any : FileType.custom,
      allowedExtensions: extensions,
    );

    List<String> selectedFiles = [];

    if (file != null) {
      for (var f in file.files) {
        selectedFiles.add(f.path!);
      }
    }

    return selectedFiles;
  }

  static Future<List<String>> imagePicker() async {
    var file = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    List<String> selectedFiles = [];

    if (file != null) {
      for (var f in file.files) {
        selectedFiles.add(f.path!);
      }
    }

    return selectedFiles;
  }

  static Future<String?> folderPicker([String? dialogTitle]) async {
    String? path =
        await FilePicker.platform.getDirectoryPath(dialogTitle: dialogTitle);

    return path;
  }

  static Future<void> copyFile(String from, String to) async {
    await File(from).copy(to);
  }

  static Future<void> deleteFile(String filePath) async {
    await File(filePath).delete();
  }
}
