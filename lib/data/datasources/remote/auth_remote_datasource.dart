import '../../models/user_profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserProfileModel> login(String email, String password);

  Future<UserProfileModel> register(String email, String password, String name);

  Future<void> resetPassword(String email);

  Future<void> logout();

  Future<UserProfileModel> getCurrentUser();
}
