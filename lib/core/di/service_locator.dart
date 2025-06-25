import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/dashboard/cubit/dashboard_cubit.dart';
import '../../shared/services/http_service.dart';
import '../../shared/services/navigation_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core Services
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<HttpService>(() => HttpService());
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());

  // Cubits
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<HttpService>()));
  getIt.registerFactory<DashboardCubit>(() => DashboardCubit());
}
