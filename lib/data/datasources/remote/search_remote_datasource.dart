import '../../models/user_profile_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<UserProfileModel>> searchProfiles(String query);
}
