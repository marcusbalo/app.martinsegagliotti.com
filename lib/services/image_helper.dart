import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelperService {
  List<String> paths = [];
  ImageHelperService();

  addImagePath(String path) {
    this.paths.add(path);
  }

  removeImagePath({String path, int index}) {
    if (index != null) {
      paths.removeAt(index);
    } else if (path != null) {
      paths.removeWhere((element) => element == path);
    }
  }

  getImagePath(int index) {
    return paths.elementAt(index);
  }

  clearPaths() {
    paths = [];
  }

  static Future<String> createOrGetImageFolder() async {
    final String folderName = "imagens_pendentes";
    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/$folderName');

    if (await _appDocDirFolder.exists()) {
      return _appDocDirFolder.path;
    } else {
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  static Future<void> clearTempFolder([String path]) async {
    if (path != null) {
      File(path).deleteSync();
    } else {
      final String folderName = "imagens_pendentes";
      final Directory _appDocDir = await getApplicationDocumentsDirectory();
      final Directory _appDocDirFolder =
          Directory('${_appDocDir.path}/$folderName');
      if (await _appDocDirFolder.exists()) {
        _appDocDirFolder.delete(recursive: true);
      }
    }
  }

  static Future<void> deleteFromList(List<String> paths) async {
    if (paths != null) {
      for (var path in paths) {
        clearTempFolder(path);
      }
    }
  }

  Future<String> toDisk(String originalpath) async {
    final File image = File(originalpath);
    final String root = await createOrGetImageFolder();
    final filename = basename(originalpath);
    final File localImage = await image.copy('$root/$filename');
    return localImage.path;
  }
}
