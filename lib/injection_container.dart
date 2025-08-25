import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/calculator/data/datasources/calculator_local_datasource.dart';
import 'features/calculator/data/repositories/calculator_repository_impl.dart';
import 'features/calculator/domain/repositories/calculator_repository.dart';
import 'features/calculator/domain/usecases/add_numbers.dart';
import 'features/calculator/domain/usecases/get_calculation_history.dart';
import 'features/calculator/domain/usecases/clear_history.dart';
import 'features/calculator/domain/usecases/validate_input.dart';
import 'features/calculator/presentation/controllers/calculator_controller.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Controllers
  sl.registerFactory(
    () => CalculatorController(
      addNumbers: sl(),
      getCalculationHistory: sl(),
      clearHistory: sl(),
      validateInput: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => AddNumbers(sl()));
  sl.registerLazySingleton(() => GetCalculationHistory(sl()));
  sl.registerLazySingleton(() => ClearHistory(sl()));
  sl.registerLazySingleton(() => ValidateInput(sl()));

  // Repository
  sl.registerLazySingleton<CalculatorRepository>(
    () => CalculatorRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<CalculatorLocalDataSource>(
    () => CalculatorLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
