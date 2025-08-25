import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:string_calculator_kata/core/errors/exceptions.dart';
import 'package:string_calculator_kata/core/errors/failures.dart';
import 'package:string_calculator_kata/features/calculator/data/datasources/calculator_local_datasource.dart';
import 'package:string_calculator_kata/features/calculator/data/models/calculation_result_model.dart';
import 'package:string_calculator_kata/features/calculator/data/repositories/calculator_repository_impl.dart';

import 'calculator_repository_impl_test.mocks.dart';

@GenerateMocks([CalculatorLocalDataSource])
void main() {
  late CalculatorRepositoryImpl repository;
  late MockCalculatorLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockCalculatorLocalDataSource();

    repository = CalculatorRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('addNumbers', () {
    const testInput = '1,2,3';
    const testResult = CalculationResultModel(value: 6, isValid: true);

    test(
      'should return calculation result when the call to local data source is successful',
      () async {
        when(
          mockLocalDataSource.addNumbers(testInput),
        ).thenAnswer((_) async => testResult);

        final result = await repository.addNumbers(testInput);

        verify(mockLocalDataSource.addNumbers(testInput));
        expect(result, equals(const Right(testResult)));
      },
    );

    test(
      'should return ValidationFailure when the call to local data source throws ValidationException',
      () async {
        when(
          mockLocalDataSource.addNumbers(testInput),
        ).thenThrow(const ValidationException('Invalid input'));

        final result = await repository.addNumbers(testInput);

        verify(mockLocalDataSource.addNumbers(testInput));
        expect(result, equals(const Left(ValidationFailure('Invalid input'))));
      },
    );

    test(
      'should return CacheFailure when the call to local data source throws CacheException',
      () async {
        when(
          mockLocalDataSource.addNumbers(testInput),
        ).thenThrow(const CacheException('Cache error'));

        final result = await repository.addNumbers(testInput);

        verify(mockLocalDataSource.addNumbers(testInput));
        expect(result, equals(const Left(CacheFailure('Cache error'))));
      },
    );
  });
}
