import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/calculator_controller.dart';

class CalculationHistoryWidget extends StatelessWidget {
  const CalculationHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();

    return Obx(() {
      if (!controller.hasHistory) {
        return const SizedBox.shrink();
      }

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(
                    () => TextButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.clearCalculationHistory,
                      icon: controller.isLoading.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.clear_all),
                      label: const Text('Clear'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...controller.history.map(
                (calculation) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    controller.getHistoryEntry(calculation),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
