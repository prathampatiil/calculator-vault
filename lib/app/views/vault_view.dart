import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/vault_controller.dart';
import '../services/secret_service.dart';

class VaultView extends StatelessWidget {
  VaultView({super.key});

  final controller = Get.put(VaultController());
  final secretService = SecretService();

  // ---------------- ADD SECRET DIALOG ----------------
  void _addSecretDialog() {
    final textController = TextEditingController();

    Get.defaultDialog(
      title: "Add Secret Expression",
      content: Column(
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Example: 2+2"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final expression = textController.text.trim();
              if (expression.isEmpty) return;

              // Each vault gets unique ID
              final vaultId = DateTime.now().millisecondsSinceEpoch.toString();

              await secretService.addSecret(expression, vaultId);

              Get.back();
              Get.snackbar("Success", "Secret added successfully");
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // ---------------- CONFIRM DELETE ----------------
  void _confirmDelete() {
    if (controller.selected.isEmpty) return;

    Get.defaultDialog(
      title: "Delete Images",
      middleText: "Delete ${controller.selected.length} selected image(s)?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await controller.deleteSelected();
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Obx(
          () => Text(
            controller.selected.isEmpty
                ? "Hidden Vault"
                : "${controller.selected.length} selected",
          ),
        ),
        actions: [
          // ➕ Add Secret Button (always visible)
          IconButton(icon: const Icon(Icons.add), onPressed: _addSecretDialog),

          // 🗑 Delete Button (only when selection exists)
          Obx(
            () => controller.selected.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _confirmDelete,
                  )
                : const SizedBox(),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F7DF3),
        onPressed: controller.pickImages,
        child: const Icon(Icons.add),
      ),

      body: Obx(() {
        if (controller.images.isEmpty) {
          return const Center(
            child: Text(
              "No hidden photos",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (_, i) {
            final photo = controller.images[i];
            final isSelected = controller.isSelected(photo);

            return GestureDetector(
              onLongPress: () => controller.toggleSelection(photo),
              onTap: () {
                if (controller.selected.isNotEmpty) {
                  controller.toggleSelection(photo);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.file(
                        photo.file,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                    // ✅ Selection Overlay
                    if (isSelected)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check_circle,
                            size: 42,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
