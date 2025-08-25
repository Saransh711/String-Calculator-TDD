import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/calculation.dart';
import '../repositories/calculator_repository.dart';

class GetCalculationHistory implements UseCase<List<Calculation>, NoParams> {
  final CalculatorRepository repository;

  GetCalculationHistory(this.repository);

  @override
  Future<Either<Failure, List<Calculation>>> call(NoParams params) async {
    return await repository.getCalculationHistory();
  }
}
