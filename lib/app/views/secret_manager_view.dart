import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/secret_service.dart';

class SecretManagerView extends StatefulWidget {
  const SecretManagerView({super.key});

  @override
  State<SecretManagerView> createState() => _SecretManagerViewState();
}

class _SecretManagerViewState extends State<SecretManagerView> {
  final service = SecretService();
  Map<String, SecretEntry> secrets = {};

  @override
  void initState() {
    load();
    super.initState();
  }

  Future<void> load() async {
    secrets = await service.loadSecrets();
    setState(() {});
  }

  void rename(String expression) {
    final controller = TextEditingController(text: secrets[expression]?.name);

    Get.defaultDialog(
      title: "Rename Vault",
      content: Column(
        children: [
          TextField(controller: controller),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await service.renameVault(expression, controller.text);
              Get.back();
              load();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> remove(String expression) async {
    await service.deleteSecret(expression);
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Secret Manager")),
      body: secrets.isEmpty
          ? const Center(child: Text("No secrets created"))
          : ListView(
              children: secrets.entries.map((e) {
                return ListTile(
                  title: Text(e.value.name),
                  subtitle: Text("Expression: ${e.key}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => rename(e.key),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => remove(e.key),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}
