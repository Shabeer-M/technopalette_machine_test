import 'dart:convert';
import '../../../core/storage/local_storage_repository.dart';
import '../../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheProfile(UserProfileModel profile);

  Future<UserProfileModel?> getCachedProfile(String userId);

  Future<void> clearProfile(String userId);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final LocalStorageRepository localStorageRepository;

  ProfileLocalDataSourceImpl({required this.localStorageRepository});

  @override
  Future<void> cacheProfile(UserProfileModel profile) async {
    final jsonString = json.encode(profile.toJson());
    await localStorageRepository.saveString(
      'profile_${profile.id}',
      jsonString,
    );
  }

  @override
  Future<UserProfileModel?> getCachedProfile(String userId) async {
    final jsonString = await localStorageRepository.getString(
      'profile_$userId',
    );
    if (jsonString != null) {
      return UserProfileModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearProfile(String userId) async {
    await localStorageRepository.delete('profile_$userId');
  }
}
