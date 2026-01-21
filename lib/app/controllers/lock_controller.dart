import 'package:get/get.dart';
import '../services/pin_service.dart';
import '../routes/app_routes.dart';

class LockController extends GetxController {
  final pinService = PinService();
  final enteredPin = "".obs;
  final isFirstTime = false.obs;

  @override
  void onInit() {
    checkFirstTime();
    super.onInit();
  }

  Future<void> checkFirstTime() async {
    isFirstTime.value = !(await pinService.pinExists());
  }

  void addDigit(String digit) {
    if (enteredPin.value.length >= 6) return;
    enteredPin.value += digit;
  }

  void clear() {
    enteredPin.value = "";
  }

  Future<void> submit() async {
    if (enteredPin.value.length < 4) return;

    if (isFirstTime.value) {
      await pinService.savePin(enteredPin.value);
      Get.offAllNamed(AppRoutes.calculator);
    } else {
      final ok = await pinService.verifyPin(enteredPin.value);
      if (ok) {
        Get.offAllNamed(AppRoutes.calculator);
      } else {
        Get.snackbar("Wrong PIN", "Try again");
        clear();
      }
    }
  }
}
