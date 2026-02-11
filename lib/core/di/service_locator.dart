import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource_impl.dart';
import '../../data/datasources/remote/profile_remote_datasource.dart';
import '../../data/datasources/remote/profile_remote_datasource_impl.dart';
import '../../data/datasources/remote/search_remote_datasource.dart';
import '../../data/datasources/remote/search_remote_datasource_impl.dart';
import '../../data/datasources/local/search_local_datasource.dart';
import '../../data/datasources/local/search_local_datasource_impl.dart';
import '../../data/datasources/local/profile_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/reset_password_usecase.dart';
import '../../domain/usecases/profile/get_profile_usecase.dart';
import '../../domain/usecases/profile/search_profiles_usecase.dart';
import '../../domain/usecases/profile/get_cached_search_results_usecase.dart';
import '../../domain/usecases/profile/update_profile_usecase.dart';
import '../../presentation/auth/bloc/auth_bloc.dart';
import '../../presentation/profile/bloc/profile_bloc.dart';
import '../../presentation/search/bloc/search_bloc.dart';
import '../storage/hive_storage_repository.dart';
import '../storage/local_storage_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ProfileBloc(getProfileUseCase: sl(), updateProfileUseCase: sl()),
  );

  sl.registerFactory(
    () => SearchBloc(
      searchProfilesUseCase: sl(),
      getCachedSearchResultsUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => SearchProfilesUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedSearchResultsUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localStorageRepository: sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(firestore: sl(), storage: sl()),
  );

  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(localStorageRepository: sl()),
  );

  sl.registerLazySingleton<SearchLocalDataSource>(
    () => SearchLocalDataSourceImpl(localStorageRepository: sl()),
  );

  sl.registerLazySingleton<LocalStorageRepository>(
    () => HiveStorageRepository(),
  );

  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);


}
