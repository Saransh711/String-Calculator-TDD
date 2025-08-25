import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/calculation.dart';
import '../entities/calculation_result.dart';

abstract class CalculatorRepository {
  Future<Either<Failure, CalculationResult>> addNumbers(String input);
  Future<Either<Failure, List<Calculation>>> getCalculationHistory();
  Future<Either<Failure, void>> saveCalculation(Calculation calculation);
  Future<Either<Failure, void>> clearHistory();
  Future<Either<Failure, bool>> validateInput(String input);
  List<String> getExamples();
}
