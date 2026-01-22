import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SecretEntry {
  final String vaultId;
  String name;

  SecretEntry({required this.vaultId, required this.name});

  Map<String, dynamic> toJson() => {"vaultId": vaultId, "name": name};

  factory SecretEntry.fromJson(Map<String, dynamic> json) {
    return SecretEntry(vaultId: json["vaultId"], name: json["name"]);
  }
}

class SecretService {
  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/secrets.json");
  }

  // ✅ MIGRATION SAFE LOADER
  Future<Map<String, SecretEntry>> loadSecrets() async {
    final file = await _file();
    if (!await file.exists()) return {};

    final text = await file.readAsString();
    if (text.trim().isEmpty) return {};

    final raw = jsonDecode(text) as Map<String, dynamic>;
    final Map<String, SecretEntry> result = {};

    raw.forEach((key, value) {
      // 🟢 New format
      if (value is Map<String, dynamic>) {
        result[key] = SecretEntry.fromJson(value);
      }
      // 🟡 Old format migration: "2+2": "A"
      else if (value is String) {
        result[key] = SecretEntry(vaultId: value, name: "Vault $value");
      }
    });

    // Persist migrated structure
    await _save(result);
    return result;
  }

  Future<void> _save(Map<String, SecretEntry> secrets) async {
    final file = await _file();
    final data = secrets.map((k, v) => MapEntry(k, v.toJson()));
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> addSecret(String expression, String vaultId, String name) async {
    final secrets = await loadSecrets();
    secrets[expression] = SecretEntry(vaultId: vaultId, name: name);
    await _save(secrets);
  }

  Future<void> deleteSecret(String expression) async {
    final secrets = await loadSecrets();
    secrets.remove(expression);
    await _save(secrets);
  }

  Future<void> renameVault(String expression, String newName) async {
    final secrets = await loadSecrets();
    final entry = secrets[expression];
    if (entry != null) {
      entry.name = newName;
      await _save(secrets);
    }
  }

  Future<SecretEntry?> findVault(String expression) async {
    final secrets = await loadSecrets();
    return secrets[expression];
  }
}
