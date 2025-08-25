import 'package:flutter/material.dart';

class InstructionsWidget extends StatelessWidget {
  const InstructionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How to use:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Empty string returns 0'),
            const Text('• Comma-separated numbers: "1,2,3"'),
            const Text('• Newlines as delimiters: "1\\n2,3"'),
            const Text('• Custom delimiters: "//;\\n1;2"'),
            const Text('• Negative numbers throw exceptions'),
          ],
        ),
      ),
    );
  }
}
