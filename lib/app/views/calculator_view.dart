import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';

class CalculatorView extends StatelessWidget {
  CalculatorView({super.key});

  final controller = Get.put(CalculatorController());

  final buttons = [
    "7",
    "8",
    "9",
    "÷",
    "4",
    "5",
    "6",
    "×",
    "1",
    "2",
    "3",
    "-",
    "0",
    ".",
    "=",
    "+",
    "C",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculator")),
      body: Column(
        children: [
          Obx(
            () => Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                controller.display.value,
                style: const TextStyle(fontSize: 42),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) {
                final text = buttons[i];
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => controller.onButtonPress(text),
                  child: Text(text, style: const TextStyle(fontSize: 22)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
