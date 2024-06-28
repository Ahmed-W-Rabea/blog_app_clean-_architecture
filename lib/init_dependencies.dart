import 'package:authentication_blogs/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:authentication_blogs/core/secrets/app_secrets.dart';
import 'package:authentication_blogs/features/auth/data/datasources/auth_remota_datasource.dart';
import 'package:authentication_blogs/features/auth/data/repositories/auth_repository_implementaion.dart';
import 'package:authentication_blogs/features/auth/domain/repository/auth_repository.dart';
import 'package:authentication_blogs/features/auth/domain/usecases/current_user.dart';
import 'package:authentication_blogs/features/auth/domain/usecases/user_login.dart';
import 'package:authentication_blogs/features/auth/domain/usecases/user_sign_up.dart';
import 'package:authentication_blogs/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  //Data source
  serviceLocator
    ..registerFactory<AuthRemotaDataSource>(
        () => AuthRemotaDatasourceImpl(serviceLocator()))
    //Repository
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImplementaion(serviceLocator()))
    // Usecases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    //Bloc
    ..registerLazySingleton(() => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator(),
        ));
}
