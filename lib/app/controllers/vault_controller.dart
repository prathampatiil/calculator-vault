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

  @override
  void onInit() {
    loadImages();
    super.onInit();
  }

  // ---------------- LOAD IMAGES ----------------
  Future<void> loadImages() async {
    final files = await storage.loadImages();
    images.value = files
        .map((f) => PhotoModel(file: f, createdAt: DateTime.now()))
        .toList();
  }

  // ---------------- PICK MULTIPLE IMAGES ----------------
  Future<void> pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isEmpty) return;

    for (final img in picked) {
      await storage.saveImage(File(img.path));
    }

    loadImages();
  }

  // ---------------- SELECTION ----------------
  void toggleSelection(PhotoModel photo) {
    if (selected.contains(photo)) {
      selected.remove(photo);
    } else {
      selected.add(photo);
    }
  }

  bool isSelected(PhotoModel photo) {
    return selected.contains(photo);
  }

  void clearSelection() {
    selected.clear();
  }

  // ---------------- DELETE ----------------
  Future<void> deleteSelected() async {
    for (final photo in selected) {
      if (await photo.file.exists()) {
        await photo.file.delete();
      }
    }

    clearSelection();
    loadImages();
  }
}
