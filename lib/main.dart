import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_routes.dart';
import 'app/views/calculator_view.dart';
import 'app/views/vault_view.dart';

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
      initialRoute: AppRoutes.calculator,
      getPages: [
        GetPage(name: AppRoutes.calculator, page: () => CalculatorView()),
        GetPage(name: AppRoutes.vault, page: () => VaultView()),
      ],
    );
  }
}
