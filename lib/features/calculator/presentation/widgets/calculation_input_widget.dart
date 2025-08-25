import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/calculator_controller.dart';

class CalculationInputWidget extends StatelessWidget {
  const CalculationInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalculatorController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Input:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.inputController,
              decoration: const InputDecoration(
                hintText: 'Enter numbers (e.g., "1,2,3" or "//;\\n1;2")',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              minLines: 1,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => ElevatedButton.icon(
                      onPressed: controller.canCalculate
                          ? controller.calculateSum
                          : null,
                      icon: controller.isCalculating.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.calculate),
                      label: Text(
                        controller.isCalculating.value
                            ? 'Calculating...'
                            : 'Calculate',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: controller.clearInput,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
