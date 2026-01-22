import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<Directory> _vaultDir(String vaultId) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory("${base.path}/.vault_$vaultId");
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<List<File>> loadImages(String vaultId) async {
    final dir = await _vaultDir(vaultId);
    return dir.listSync().whereType<File>().toList();
  }

  Future<File> saveImage(File source, String vaultId) async {
    final dir = await _vaultDir(vaultId);
    final name = DateTime.now().millisecondsSinceEpoch;
    final target = File("${dir.path}/$name.jpg");

    final bytes = await source.readAsBytes();
    await target.writeAsBytes(bytes, flush: true);

    return target;
  }
}
