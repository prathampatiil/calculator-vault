import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/pin_service.dart';

class CalculatorController extends GetxController {
  final display = "0".obs;

  String currentInput = "";
  double? storedValue;
  String? operator;
  bool isNewInput = true;

  final pinService = PinService();
  String pinBuffer = "";

  void onButtonPress(String value) {
    _trackPin(value);

    if (value == "C") {
      _reset();
      return;
    }

    if (_isDigit(value) || value == ".") {
      _handleNumber(value);
    } else if (_isOperator(value)) {
      _handleOperator(value);
    } else if (value == "=") {
      _calculate();
    }
  }

  // ---------------- PIN TRACKER ----------------
  Future<void> _trackPin(String value) async {
    if (!_isDigit(value)) return;

    pinBuffer += value;
    if (pinBuffer.length > 6) {
      pinBuffer = pinBuffer.substring(pinBuffer.length - 6);
    }

    if (await pinService.verifyPin(pinBuffer)) {
      pinBuffer = "";
      Get.toNamed(AppRoutes.vault);
    }
  }

  // ---------------- NUMBER INPUT ----------------
  void _handleNumber(String value) {
    if (isNewInput) {
      currentInput = value == "." ? "0." : value;
      isNewInput = false;
    } else {
      if (value == "." && currentInput.contains(".")) return;
      currentInput += value;
    }

    _updateDisplay();
  }

  // ---------------- OPERATOR INPUT ----------------
  void _handleOperator(String op) {
    // Case: First operator
    if (storedValue == null && currentInput.isNotEmpty) {
      storedValue = double.tryParse(currentInput);
    }
    // Case: Continuous calculation
    else if (storedValue != null &&
        currentInput.isNotEmpty &&
        operator != null) {
      final current = double.tryParse(currentInput);
      if (current != null) {
        storedValue = _apply(storedValue!, current, operator!);
      }
    }

    operator = op;

    // Reset input for next number
    currentInput = "";
    isNewInput = true;

    // ✅ Show intermediate result + operator
    display.value = "${_format(storedValue ?? 0)}$operator";
  }

  // ---------------- CALCULATE ----------------
  void _calculate() {
    if (storedValue == null || operator == null || currentInput.isEmpty) return;

    final current = double.tryParse(currentInput);
    if (current == null) return;

    final result = _apply(storedValue!, current, operator!);

    display.value = _format(result);

    // Prepare for next chain
    storedValue = result;
    operator = null;
    currentInput = "";
    isNewInput = true;
  }

  // ---------------- ENGINE ----------------
  double _apply(double a, double b, String op) {
    switch (op) {
      case "+":
        return a + b;
      case "-":
        return a - b;
      case "×":
        return a * b;
      case "÷":
        if (b == 0) {
          _reset();
          return 0;
        }
        return a / b;
      default:
        return b;
    }
  }

  // ---------------- RESET ----------------
  void _reset() {
    display.value = "0";
    currentInput = "";
    storedValue = null;
    operator = null;
    isNewInput = true;
    pinBuffer = "";
  }

  // ---------------- UTIL ----------------
  bool _isDigit(String v) => RegExp(r'[0-9]').hasMatch(v);
  bool _isOperator(String v) => ["+", "-", "×", "÷"].contains(v);

  String _format(double v) => v % 1 == 0 ? v.toInt().toString() : v.toString();

  void _updateDisplay() {
    final buffer = StringBuffer();

    if (storedValue != null) {
      buffer.write(_format(storedValue!));
    }

    if (operator != null) {
      buffer.write(operator);
    }

    buffer.write(currentInput);

    display.value = buffer.isEmpty ? "0" : buffer.toString();
  }
}
