import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lock_controller.dart';

class LockView extends StatelessWidget {
  LockView({super.key});

  final controller = Get.put(LockController());

  final keys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Secure Access")),
      body: Column(
        children: [
          const SizedBox(height: 40),

          Obx(
            () => Text(
              controller.isFirstTime.value ? "Create PIN" : "Enter PIN",
              style: const TextStyle(fontSize: 24),
            ),
          ),

          const SizedBox(height: 20),

          Obx(
            () => Text(
              "*" * controller.enteredPin.value.length,
              style: const TextStyle(fontSize: 32),
            ),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(20),
              children: [
                ...keys.map(
                  (k) => ElevatedButton(
                    onPressed: () => controller.addDigit(k),
                    child: Text(k, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                ElevatedButton(
                  onPressed: controller.clear,
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: controller.submit,
                  child: const Text("OK"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
