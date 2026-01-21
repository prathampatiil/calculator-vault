import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<Directory> _vaultDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory("${base.path}/.vault");
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<List<File>> loadImages() async {
    final dir = await _vaultDir();
    return dir.listSync().whereType<File>().toList();
  }

  Future<File> saveImage(File source) async {
    final dir = await _vaultDir();
    final name = DateTime.now().millisecondsSinceEpoch;
    return source.copy("${dir.path}/$name.jpg");
  }
}
