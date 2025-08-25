import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/calculator_repository.dart';

class ValidateInput implements UseCase<bool, ValidateInputParams> {
  final CalculatorRepository repository;

  ValidateInput(this.repository);

  @override
  Future<Either<Failure, bool>> call(ValidateInputParams params) async {
    return await repository.validateInput(params.input);
  }
}

class ValidateInputParams {
  final String input;

  const ValidateInputParams({required this.input});
}
