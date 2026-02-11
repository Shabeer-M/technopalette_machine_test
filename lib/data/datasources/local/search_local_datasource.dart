import '../../models/user_profile_model.dart';

abstract class SearchLocalDataSource {
  Future<void> cacheSearchResults(String query, List<UserProfileModel> results);
  Future<List<UserProfileModel>> getCachedSearchResults(String query);
}
