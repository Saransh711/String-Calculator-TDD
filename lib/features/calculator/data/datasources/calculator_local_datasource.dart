import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/calculation_model.dart';
import '../models/calculation_result_model.dart';

abstract class CalculatorLocalDataSource {
  Future<CalculationResultModel> addNumbers(String input);
  Future<List<CalculationModel>> getCalculationHistory();
  Future<void> saveCalculation(CalculationModel calculation);
  Future<void> clearHistory();
  Future<bool> validateInput(String input);
  List<String> getExamples();
}

class CalculatorLocalDataSourceImpl implements CalculatorLocalDataSource {
  final SharedPreferences sharedPreferences;

  CalculatorLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<CalculationResultModel> addNumbers(String input) async {
    try {
      if (input.isEmpty) {
        return const CalculationResultModel(value: 0, isValid: true);
      }

      String delimiter = ',';
      String numbersToProcess = input;

      if (input.startsWith('//')) {
        int delimiterEndIndex = input.indexOf('\n');
        if (delimiterEndIndex != -1) {
          delimiter = input.substring(2, delimiterEndIndex);
          numbersToProcess = input.substring(delimiterEndIndex + 1);
        }
      }

      numbersToProcess = numbersToProcess.replaceAll('\n', delimiter);

      List<String> numberStrings = numbersToProcess.split(delimiter);
      List<int> negativeNumbers = [];
      int sum = 0;

      for (String numberStr in numberStrings) {
        if (numberStr.trim().isNotEmpty) {
          int number = int.parse(numberStr.trim());

          if (number < 0) {
            negativeNumbers.add(number);
          } else {
            sum += number;
          }
        }
      }

      if (negativeNumbers.isNotEmpty) {
        return CalculationResultModel(
          value: 0,
          isValid: false,
          errorMessage:
              'negative numbers not allowed ${negativeNumbers.join(',')}',
          negativeNumbers: negativeNumbers,
        );
      }

      return CalculationResultModel(value: sum, isValid: true);
    } catch (e) {
      throw ValidationException('Invalid input format: ${e.toString()}');
    }
  }

  @override
  Future<List<CalculationModel>> getCalculationHistory() async {
    try {
      final jsonString = sharedPreferences.getString(AppConstants.historyKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => CalculationModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException(
        'Failed to get calculation history: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> saveCalculation(CalculationModel calculation) async {
    try {
      final history = await getCalculationHistory();
      history.insert(0, calculation);

      if (history.length > AppConstants.maxHistoryItems) {
        history.removeRange(AppConstants.maxHistoryItems, history.length);
      }

      final jsonString = json.encode(
        history.map((calc) => calc.toJson()).toList(),
      );

      await sharedPreferences.setString(AppConstants.historyKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to save calculation: ${e.toString()}');
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      await sharedPreferences.remove(AppConstants.historyKey);
    } catch (e) {
      throw CacheException('Failed to clear history: ${e.toString()}');
    }
  }

  @override
  Future<bool> validateInput(String input) async {
    try {
      await addNumbers(input);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  List<String> getExamples() {
    return AppConstants.calculatorExamples;
  }
}
