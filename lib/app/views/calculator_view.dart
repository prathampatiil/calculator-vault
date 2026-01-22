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
    "⌫",
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

  bool _isOperator(String v) => ["+", "-", "×", "÷", "="].contains(v);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        title: const Text("Calculator"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // 🔢 Display Panel
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF1E2026), Color(0xFF121418)],
              ),
            ),
            alignment: Alignment.centerRight,
            child: Obx(
              () => Text(
                controller.display.value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // 🧮 Buttons
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemBuilder: (_, i) {
                final text = buttons[i];
                final isOp = _isOperator(text);

                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => controller.onButtonPress(text),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: isOp
                          ? const Color(0xFF4F7DF3)
                          : const Color(0xFF1C1F26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: isOp ? Colors.white : Colors.grey[200],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
