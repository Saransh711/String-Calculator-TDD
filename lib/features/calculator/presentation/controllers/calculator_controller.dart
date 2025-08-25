import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/calculation.dart';
import '../../domain/usecases/add_numbers.dart';
import '../../domain/usecases/clear_history.dart';
import '../../domain/usecases/get_calculation_history.dart';
import '../../domain/usecases/validate_input.dart';

class CalculatorController extends GetxController {
  final AddNumbers addNumbers;
  final GetCalculationHistory getCalculationHistory;
  final ClearHistory clearHistory;
  final ValidateInput validateInput;

  CalculatorController({
    required this.addNumbers,
    required this.getCalculationHistory,
    required this.clearHistory,
    required this.validateInput,
  });

  final TextEditingController inputController = TextEditingController();

  final RxString result = ''.obs;
  final RxString error = ''.obs;
  final RxList<Calculation> history = <Calculation>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCalculating = false.obs;

  // Examples for UI
  final List<String> examples = [
    '""',
    '"1"',
    '"1,2"',
    '"1,2,3"',
    '"1\\n2,3"',
    '"//;\\n1;2"',
    '"//|\\n1|2|3"',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  Future<void> calculateSum() async {
    if (isCalculating.value) return;

    isCalculating.value = true;
    error.value = '';
    result.value = '';

    try {
      final input = inputController.text;
      final params = AddNumbersParams(input: input);
      final either = await addNumbers(params);

      either.fold(
        (failure) {
          error.value = failure.message;
          result.value = '';
        },
        (calculation) {
          result.value = calculation.result.toString();
          error.value = '';
          _loadHistory();
        },
      );
    } catch (e) {
      error.value = 'Unexpected error: ${e.toString()}';
      result.value = '';
    } finally {
      isCalculating.value = false;
    }
  }

  void clearInput() {
    inputController.clear();
    result.value = '';
    error.value = '';
  }

  Future<void> clearCalculationHistory() async {
    try {
      isLoading.value = true;
      final either = await clearHistory(const NoParams());

      either.fold(
        (failure) {
          Get.snackbar(
            'Error',
            'Failed to clear history: ${failure.message}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            colorText: Colors.white,
          );
        },
        (_) {
          history.clear();
          Get.snackbar(
            'Success',
            'History cleared successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.8),
            colorText: Colors.white,
          );
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void useExample(String example) {
    final cleanExample = example.cleanExample();
    inputController.text = cleanExample;
    error.value = '';
    result.value = '';
  }

  Future<void> _loadHistory() async {
    try {
      isLoading.value = true;
      final either = await getCalculationHistory(const NoParams());

      either.fold(
        (failure) {
          if (kDebugMode) {
            print(failure);
          }
        },
        (calculations) {
          history.assignAll(calculations);
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasResult => result.value.isNotEmpty;
  bool get hasError => error.value.isNotEmpty;
  bool get hasHistory => history.isNotEmpty;
  bool get canCalculate => !isCalculating.value;

  String getHistoryEntry(Calculation calculation) {
    return 'add("${calculation.input}") = ${calculation.result}';
  }
}
