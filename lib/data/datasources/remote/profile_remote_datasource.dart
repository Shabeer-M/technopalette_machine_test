import 'dart:io';
import '../../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile(String userId);

  Future<UserProfileModel> updateProfile(
    UserProfileModel profile, {
    File? image,
  });

  Future<List<UserProfileModel>> searchProfiles(String query);
}
