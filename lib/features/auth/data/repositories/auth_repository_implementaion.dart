import 'package:authentication_blogs/core/constants/constants.dart';
import 'package:authentication_blogs/core/error/exceptions.dart';
import 'package:authentication_blogs/core/error/failure.dart';
import 'package:authentication_blogs/core/network/connection_checker.dart';
import 'package:authentication_blogs/features/auth/data/datasources/auth_remota_datasource.dart';
import 'package:authentication_blogs/core/common/entities/user.dart';
import 'package:authentication_blogs/features/auth/data/models/user_model.dart';
import 'package:authentication_blogs/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImplementaion implements AuthRepository {
  final AuthRemotaDataSource remotaDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImplementaion(this.remotaDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remotaDataSource.currentUserSessin;
        if (session == null) {
          return left(Failure(message: Constants.noConnectionErrorMessage));
        }
        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }
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
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(message: 'No internet connection!'));
      }
      final user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
