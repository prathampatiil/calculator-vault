import 'dart:io';
import 'package:get/get.dart';
import '../models/photo_model.dart';
import '../services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class VaultController extends GetxController {
  final images = <PhotoModel>[].obs;
  final picker = ImagePicker();
  final storage = StorageService();

  @override
  void onInit() {
    loadImages();
    super.onInit();
  }

  Future<void> loadImages() async {
    final files = await storage.loadImages();
    images.value = files
        .map((f) => PhotoModel(file: f, createdAt: DateTime.now()))
        .toList();
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    await storage.saveImage(File(picked.path));
    loadImages();
  }
}
