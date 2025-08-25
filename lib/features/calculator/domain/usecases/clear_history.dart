import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/calculator_repository.dart';

class ClearHistory implements UseCase<void, NoParams> {
  final CalculatorRepository repository;

  ClearHistory(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearHistory();
  }
}
