import 'package:flutter_application_api_bloc/core/services/firebase_firestore_service.dart';
import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_cubit.dart';
import 'package:flutter_application_api_bloc/features/add_task/data/repository/tasks_repository_implement.dart';
import 'package:flutter_application_api_bloc/features/auth/cubit/login_cubit.dart';
import 'package:flutter_application_api_bloc/features/auth/cubit/register_cubit.dart';
import 'package:flutter_application_api_bloc/features/auth/data/repository/auth_repository_implement.dart';
import 'package:flutter_application_api_bloc/features/home/cubit/home_cubit.dart';
import 'package:flutter_application_api_bloc/features/home/data/repository/home_repository_implement.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
  // Firebase Auth Service
  locator
      .registerLazySingleton<FirebaseHomeService>(() => FirebaseHomeService());

  // API service
  locator.registerLazySingleton<TasksRepositoryImplement>(
    () => TasksRepositoryImplement(
      firebaseHomeService: locator<FirebaseHomeService>(),
    ),
  );

  locator.registerLazySingleton<AuthRepositoryImplement>(
    () => AuthRepositoryImplement(),
  );
  locator.registerLazySingleton<HomeRepositoryImplement>(
    () => HomeRepositoryImplement(firebaseHomeService:locator<FirebaseHomeService>()),
  );

  // أي BLoC
  // لو عايز Bloc يتحقن:
  // Cubit
  locator.registerFactory<TasksCubit>(
    () => TasksCubit(repository: locator<TasksRepositoryImplement>()),
  );

  locator.registerFactory<LoginCubit>(
    () => LoginCubit(locator<AuthRepositoryImplement>()),
  );
  locator.registerFactory<RegisterCubit>(
    () => RegisterCubit(locator<AuthRepositoryImplement>()),
  );
  locator.registerFactory<HomeCubit>(
    () => HomeCubit(repository: locator<HomeRepositoryImplement>()),
  );
}
