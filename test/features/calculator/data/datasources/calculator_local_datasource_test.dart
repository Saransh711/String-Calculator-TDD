import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_calculator_kata/core/constants/app_constants.dart';
import 'package:string_calculator_kata/core/errors/exceptions.dart';
import 'package:string_calculator_kata/features/calculator/data/datasources/calculator_local_datasource.dart';
import 'package:string_calculator_kata/features/calculator/data/models/calculation_model.dart';

import 'calculator_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late CalculatorLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = CalculatorLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('addNumbers', () {
    test(
      'should return CalculationResultModel with value 0 for empty string',
      () async {
        final result = await dataSource.addNumbers('');

        expect(result.value, equals(0));
        expect(result.isValid, equals(true));
      },
    );

    test(
      'should return CalculationResultModel with correct sum for comma-separated numbers',
      () async {
        final result = await dataSource.addNumbers('1,2,3');

        expect(result.value, equals(6));
        expect(result.isValid, equals(true));
      },
    );

    test(
      'should return CalculationResultModel with correct sum for newline-separated numbers',
      () async {
        final result = await dataSource.addNumbers('1\n2,3');

        expect(result.value, equals(6));
        expect(result.isValid, equals(true));
      },
    );

    test(
      'should return CalculationResultModel with correct sum for custom delimiter',
      () async {
        final result = await dataSource.addNumbers('//;\n1;2');

        expect(result.value, equals(3));
        expect(result.isValid, equals(true));
      },
    );

    test('should return error for negative numbers', () async {
      final result = await dataSource.addNumbers('1,-2,3');

      expect(result.isValid, equals(false));
      expect(result.errorMessage, contains('negative numbers not allowed'));
      expect(result.negativeNumbers, equals([-2]));
    });

    test('should throw ValidationException for invalid input', () async {
      expect(
        () => dataSource.addNumbers('1,a,3'),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('getCalculationHistory', () {
    test('should return empty list when no history exists', () async {
      when(
        mockSharedPreferences.getString(AppConstants.historyKey),
      ).thenReturn(null);

      final result = await dataSource.getCalculationHistory();

      expect(result, equals([]));
      verify(mockSharedPreferences.getString(AppConstants.historyKey));
    });

    test(
      'should return list of CalculationModel when history exists',
      () async {
        final testCalculations = [
          CalculationModel(input: '1,2', result: 3, timestamp: DateTime.now()),
        ];
        final jsonString = json.encode(
          testCalculations.map((calc) => calc.toJson()).toList(),
        );
        when(
          mockSharedPreferences.getString(AppConstants.historyKey),
        ).thenReturn(jsonString);

        final result = await dataSource.getCalculationHistory();

        expect(result.length, equals(1));
        expect(result.first.input, equals('1,2'));
        expect(result.first.result, equals(3));
        verify(mockSharedPreferences.getString(AppConstants.historyKey));
      },
    );

    test('should throw CacheException when SharedPreferences throws', () async {
      when(
        mockSharedPreferences.getString(AppConstants.historyKey),
      ).thenThrow(Exception('Storage error'));

      expect(
        () => dataSource.getCalculationHistory(),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('saveCalculation', () {
    test('should save calculation to SharedPreferences', () async {
      final testCalculation = CalculationModel(
        input: '1,2',
        result: 3,
        timestamp: DateTime.now(),
      );
      when(
        mockSharedPreferences.getString(AppConstants.historyKey),
      ).thenReturn(null);
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);

      await dataSource.saveCalculation(testCalculation);

      verify(mockSharedPreferences.getString(AppConstants.historyKey));
      verify(mockSharedPreferences.setString(AppConstants.historyKey, any));
    });
  });

  group('clearHistory', () {
    test('should remove history from SharedPreferences', () async {
      when(
        mockSharedPreferences.remove(AppConstants.historyKey),
      ).thenAnswer((_) async => true);

      await dataSource.clearHistory();

      verify(mockSharedPreferences.remove(AppConstants.historyKey));
    });
  });

  group('getExamples', () {
    test('should return list of example strings', () {
      final result = dataSource.getExamples();

      expect(result, equals(AppConstants.calculatorExamples));
    });
  });
}
