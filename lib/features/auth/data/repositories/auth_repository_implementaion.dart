import 'package:authentication_blogs/core/error/exceptions.dart';
import 'package:authentication_blogs/core/error/failure.dart';
import 'package:authentication_blogs/features/auth/data/datasources/auth_remota_datasource.dart';
import 'package:authentication_blogs/core/common/entities/user.dart';
import 'package:authentication_blogs/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImplementaion implements AuthRepository {
  final AuthRemotaDataSource remotaDataSource;

  AuthRepositoryImplementaion(this.remotaDataSource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remotaDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure(message: 'User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(() async => await remotaDataSource.loginWithEmailPassword(
        email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(() async => await remotaDataSource.signUpWithEmailPassword(
        name: name, email: email, password: password));
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return Left(Failure(message: e.message));
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
