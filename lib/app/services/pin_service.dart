import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

class PinService {
  Future<File> _pinFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/pin.dat");
  }

  String _hash(String pin) {
    return sha256.convert(utf8.encode(pin)).toString();
  }

  Future<void> savePin(String pin) async {
    final file = await _pinFile();
    await file.writeAsString(_hash(pin));
  }

  Future<bool> verifyPin(String input) async {
    final file = await _pinFile();
    if (!await file.exists()) {
      await savePin("1234");
    }
    final stored = await file.readAsString();
    return stored == _hash(input);
  }
}
