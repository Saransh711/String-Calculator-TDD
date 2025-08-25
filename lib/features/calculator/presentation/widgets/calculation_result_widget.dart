import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/calculator_controller.dart';

class CalculationResultWidget extends StatelessWidget {
  const CalculationResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();

    return Obx(() {
      if (!controller.hasResult && !controller.hasError) {
        return const SizedBox.shrink();
      }

      return Card(
        color: controller.hasError ? Colors.red[50] : Colors.green[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.hasError ? 'Error:' : 'Result:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: controller.hasError
                      ? Colors.red[700]
                      : Colors.green[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.hasError
                    ? controller.error.value
                    : controller.result.value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: controller.hasError
                      ? Colors.red[700]
                      : Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
