import 'dart:convert';
import '../../../core/storage/local_storage_repository.dart';
import '../../models/user_profile_model.dart';
import 'search_local_datasource.dart';

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final LocalStorageRepository localStorageRepository;

  SearchLocalDataSourceImpl({required this.localStorageRepository});

  @override
  Future<void> cacheSearchResults(
    String query,
    List<UserProfileModel> results,
  ) async {
    final jsonList = results.map((profile) => profile.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await localStorageRepository.saveString('search_$query', jsonString);
  }

  @override
  Future<List<UserProfileModel>> getCachedSearchResults(String query) async {
    final jsonString = await localStorageRepository.getString('search_$query');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => UserProfileModel.fromJson(json)).toList();
    }
    return [];
  }
}
