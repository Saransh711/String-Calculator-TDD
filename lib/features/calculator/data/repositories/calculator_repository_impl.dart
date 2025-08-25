import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/calculation.dart';
import '../../domain/entities/calculation_result.dart';
import '../../domain/repositories/calculator_repository.dart';
import '../datasources/calculator_local_datasource.dart';
import '../models/calculation_model.dart';

class CalculatorRepositoryImpl implements CalculatorRepository {
  final CalculatorLocalDataSource localDataSource;

  CalculatorRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, CalculationResult>> addNumbers(String input) async {
    try {
      final result = await localDataSource.addNumbers(input);
      return Right(result);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ValidationFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Calculation>>> getCalculationHistory() async {
    try {
      final history = await localDataSource.getCalculationHistory();
      return Right(history);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveCalculation(Calculation calculation) async {
    try {
      final calculationModel = CalculationModel.fromEntity(calculation);
      await localDataSource.saveCalculation(calculationModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to save calculation: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await localDataSource.clearHistory();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to clear history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateInput(String input) async {
    try {
      final isValid = await localDataSource.validateInput(input);
      return Right(isValid);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ValidationFailure('Validation failed: ${e.toString()}'));
    }
  }

  @override
  List<String> getExamples() {
    return localDataSource.getExamples();
  }
}
