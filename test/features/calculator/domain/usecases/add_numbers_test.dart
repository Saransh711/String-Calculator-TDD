import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:string_calculator_kata/features/calculator/domain/repositories/calculator_repository.dart';
import 'package:string_calculator_kata/features/calculator/domain/entities/calculation_result.dart';
import 'package:string_calculator_kata/features/calculator/domain/usecases/add_numbers.dart';
import 'package:string_calculator_kata/core/errors/failures.dart';

import 'add_numbers_test.mocks.dart';

@GenerateMocks([CalculatorRepository])
void main() {
  late AddNumbers usecase;
  late MockCalculatorRepository mockRepository;

  setUp(() {
    mockRepository = MockCalculatorRepository();
    usecase = AddNumbers(mockRepository);
  });

  group('AddNumbers', () {
    const testInput = '1,2,3';
    const testResult = CalculationResult(value: 6, isValid: true);

    test('should get calculation result from the repository', () async {
      when(
        mockRepository.addNumbers(testInput),
      ).thenAnswer((_) async => const Right(testResult));
      when(
        mockRepository.saveCalculation(any),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(const AddNumbersParams(input: testInput));

      expect(result.isRight(), true);
      result.fold((failure) => fail('Should return calculation'), (
        calculation,
      ) {
        expect(calculation.input, testInput);
        expect(calculation.result, 6);
      });
      verify(mockRepository.addNumbers(testInput));
      verify(mockRepository.saveCalculation(any));
    });

    test(
      'should return ValidationFailure when calculation is invalid',
      () async {
        const invalidResult = CalculationResult(
          value: 0,
          isValid: false,
          errorMessage: 'negative numbers not allowed -1',
        );
        when(
          mockRepository.addNumbers(testInput),
        ).thenAnswer((_) async => const Right(invalidResult));

        final result = await usecase(const AddNumbersParams(input: testInput));

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ValidationFailure>()),
          (_) => fail('Should return failure'),
        );
        verify(mockRepository.addNumbers(testInput));
        verifyNever(mockRepository.saveCalculation(any));
      },
    );

    test(
      'should return ValidationFailure when repository throws exception',
      () async {
        when(mockRepository.addNumbers(testInput)).thenAnswer(
          (_) async => const Left(ValidationFailure('Repository error')),
        );

        final result = await usecase(const AddNumbersParams(input: testInput));

        expect(result.isLeft(), true);
        verify(mockRepository.addNumbers(testInput));
        verifyNever(mockRepository.saveCalculation(any));
      },
    );
  });
}
