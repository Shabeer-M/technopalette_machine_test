import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/error/exceptions.dart';
import '../../models/user_profile_model.dart';
import 'search_remote_datasource.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final FirebaseFirestore firestore;

  SearchRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<UserProfileModel>> searchProfiles(String query) async {
    try {
      if (query.isEmpty) return [];

      final snapshot = await firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get();

      return snapshot.docs
          .map((doc) => UserProfileModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
