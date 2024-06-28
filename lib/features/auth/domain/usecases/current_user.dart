import 'package:authentication_blogs/core/error/failure.dart';
import 'package:authentication_blogs/core/usecase/usecase.dart';
import 'package:authentication_blogs/core/common/entities/user.dart';
import 'package:authentication_blogs/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return authRepository.currentUser();
  }
}
