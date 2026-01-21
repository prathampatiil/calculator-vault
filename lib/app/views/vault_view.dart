import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vault_controller.dart';

class VaultView extends StatelessWidget {
  VaultView({super.key});

  final controller = Get.put(VaultController());

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
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.selected.isEmpty
                ? "Hidden Vault"
                : "${controller.selected.length} selected",
          ),
        ),
        actions: [
          Obx(
            () => controller.selected.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _confirmDelete,
                  )
                : const SizedBox(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.pickImages,
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
            final isSelected = controller.isSelected(photo);

            return GestureDetector(
              onLongPress: () {
                controller.toggleSelection(photo);
              },
              onTap: () {
                if (controller.selected.isNotEmpty) {
                  controller.toggleSelection(photo);
                }
              },
              child: Stack(
                children: [
                  Image.file(photo.file, fit: BoxFit.cover),
                  if (isSelected)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
