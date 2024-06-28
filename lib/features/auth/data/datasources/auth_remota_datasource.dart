import 'package:authentication_blogs/core/error/exceptions.dart';
import 'package:authentication_blogs/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemotaDataSource {
  Session? get currentUserSessin;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUserData();
}

class AuthRemotaDatasourceImpl implements AuthRemotaDataSource {
  final SupabaseClient supabaseClient;

  AuthRemotaDatasourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSessin => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (response.user == null) {
        throw const ServerException('User is null');
      }
      return UserModel.fromjson(response.user!.toJson()).copyWith();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );

      if (response.user == null) {
        throw const ServerException('User is null');
      }
      return UserModel.fromjson(response.user!.toJson()).copyWith();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSessin != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSessin!.user.id);
        return UserModel.fromjson(userData.first).copyWith(
          email: currentUserSessin!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
