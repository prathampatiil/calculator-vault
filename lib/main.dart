import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_routes.dart';
import 'app/views/calculator_view.dart';
import 'app/views/vault_view.dart';
import 'app/views/lock_view.dart';
import 'app/views/secret_manager_view.dart'; // ✅ ADD THIS

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),

      // ✅ App starts from Lock Screen
      initialRoute: AppRoutes.lock,

      getPages: [
        // ✅ Lock Screen
        GetPage(name: AppRoutes.lock, page: () => LockView()),

        // ✅ Calculator
        GetPage(name: AppRoutes.calculator, page: () => CalculatorView()),

        // ✅ Vault (receives vaultId param)
        GetPage(name: AppRoutes.vault, page: () => VaultView()),

        // ✅ Secret Manager
        GetPage(name: AppRoutes.secrets, page: () => const SecretManagerView()),
      ],
    );
  }
}
