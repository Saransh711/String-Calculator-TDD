import 'package:flutter/material.dart';

import '../widgets/calculation_history_widget.dart';
import '../widgets/calculation_input_widget.dart';
import '../widgets/calculation_result_widget.dart';
import '../widgets/examples_widget.dart';
import '../widgets/instructions_widget.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('String Calculator TDD Kata'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InstructionsWidget(),
            SizedBox(height: 16),

            CalculationInputWidget(),
            SizedBox(height: 16),

            CalculationResultWidget(),
            SizedBox(height: 16),

            ExamplesWidget(),
            SizedBox(height: 16),

            CalculationHistoryWidget(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
