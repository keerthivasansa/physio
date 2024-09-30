import 'package:get_it/get_it.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/api/client.dart';
import 'package:physio/doctor/api.dart';

final locator = GetIt.instance;

void registerServices() {
  locator.registerLazySingleton(() => ApiClient());
  locator.registerLazySingleton(() => AuthState());
  locator.registerLazySingleton(() => DoctorApi());
}
