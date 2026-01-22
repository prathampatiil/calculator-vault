import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/photo_model.dart';
import '../services/storage_service.dart';

class VaultController extends GetxController {
  final images = <PhotoModel>[].obs;
  final selected = <PhotoModel>[].obs;

  final picker = ImagePicker();
  final storage = StorageService();

  late final String vaultId;

  @override
  void onInit() {
    vaultId = Get.parameters['vaultId'] ?? "default";
    loadImages();
    super.onInit();
  }

  Future<void> loadImages() async {
    final files = await storage.loadImages(vaultId);
    images.value = files
        .map((f) => PhotoModel(file: f, createdAt: DateTime.now()))
        .toList();
  }

  Future<void> pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isEmpty) return;

    for (final img in picked) {
      await storage.saveImage(File(img.path), vaultId);
    }
    loadImages();
  }

  void toggleSelection(PhotoModel photo) {
    if (selected.contains(photo)) {
      selected.remove(photo);
    } else {
      selected.add(photo);
    }
  }

  bool isSelected(PhotoModel photo) => selected.contains(photo);

  Future<void> deleteSelected() async {
    for (final photo in selected) {
      if (await photo.file.exists()) {
        await photo.file.delete();
      }
    }
    selected.clear();
    loadImages();
  }
}
