import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/calculator_controller.dart';

class ExamplesWidget extends StatelessWidget {
  const ExamplesWidget({super.key});

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
              'Examples:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.examples.map((example) {
                return ActionChip(
                  label: Text(example),
                  onPressed: () => controller.useExample(example),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
