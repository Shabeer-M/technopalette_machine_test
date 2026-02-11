import 'package:hive_flutter/hive_flutter.dart';
import 'local_storage_repository.dart';

class HiveStorageRepository implements LocalStorageRepository {
  static const String _boxName = 'app_box';

  Future<Box> get _box async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return await Hive.openBox(_boxName);
  }

  @override
  Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }

  @override
  Future<void> delete(String key) async {
    final box = await _box;
    await box.delete(key);
  }

  @override
  Future<String?> getString(String key) async {
    final box = await _box;
    return box.get(key) as String?;
  }

  @override
  Future<void> saveString(String key, String value) async {
    final box = await _box;
    await box.put(key, value);
  }
}
