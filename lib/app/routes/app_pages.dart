import 'package:get/get.dart';

import '../../features/calculator/presentation/pages/calculator_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(name: AppRoutes.calculator, page: () => const CalculatorPage()),
  ];
}
