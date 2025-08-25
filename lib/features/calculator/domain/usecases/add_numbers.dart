import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/calculation.dart';
import '../repositories/calculator_repository.dart';

class AddNumbers implements UseCase<Calculation, AddNumbersParams> {
  final CalculatorRepository repository;

  AddNumbers(this.repository);

  @override
  Future<Either<Failure, Calculation>> call(AddNumbersParams params) async {
    final result = await repository.addNumbers(params.input);

    return result.fold((failure) => Left(failure), (calculationResult) async {
      if (calculationResult.isValid) {
        final calculation = Calculation(
          input: params.input,
          result: calculationResult.value,
          timestamp: DateTime.now(),
        );

        await repository.saveCalculation(calculation);

        return Right(calculation);
      } else {
        return Left(
          ValidationFailure(
            calculationResult.errorMessage ?? 'Invalid calculation',
          ),
        );
      }
    });
  }
}

class AddNumbersParams {
  final String input;

  const AddNumbersParams({required this.input});
}
