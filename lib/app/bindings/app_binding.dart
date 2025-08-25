import 'package:get/get.dart';

import '../../features/calculator/presentation/controllers/calculator_controller.dart';
import '../../injection_container.dart' as di;

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Calculator
    Get.lazyPut<CalculatorController>(() => di.sl<CalculatorController>());
  }
}
