import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vault_controller.dart';
import '../services/pin_service.dart';

class VaultView extends StatelessWidget {
  VaultView({super.key});

  final controller = Get.put(VaultController());
  final pinService = PinService();

  void _changePin() {
    final pinController = TextEditingController();

    Get.defaultDialog(
      title: "Change PIN",
      content: Column(
        children: [
          TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 6,
            decoration: const InputDecoration(hintText: "Enter new PIN"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final pin = pinController.text.trim();
              if (pin.length < 4) {
                Get.snackbar("Invalid PIN", "Minimum 4 digits required");
                return;
              }
              await pinService.savePin(pin);
              Get.back();
              Get.snackbar("Success", "PIN changed successfully");
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hidden Vault"),
        actions: [
          IconButton(icon: const Icon(Icons.lock), onPressed: _changePin),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.pickImage,
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.images.isEmpty) {
          return const Center(child: Text("No hidden photos"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: controller.images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (_, i) {
            final photo = controller.images[i];
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(photo.file, fit: BoxFit.cover),
            );
          },
        );
      }),
    );
  }
}
