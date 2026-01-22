import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SecretService {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/secrets.json");
  }

  Future<Map<String, String>> loadSecrets() async {
    final file = await _file();
    if (!await file.exists()) return {};
    final text = await file.readAsString();
    return Map<String, String>.from(jsonDecode(text));
  }

  Future<void> saveSecrets(Map<String, String> secrets) async {
    final file = await _file();
    await file.writeAsString(jsonEncode(secrets));
  }

  Future<void> addSecret(String expression, String vaultId) async {
    final secrets = await loadSecrets();
    secrets[expression] = vaultId;
    await saveSecrets(secrets);
  }

  Future<String?> findVault(String expression) async {
    final secrets = await loadSecrets();
    return secrets[expression];
  }
}
