import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../core/error/exceptions.dart';
import '../../models/user_profile_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProfileRemoteDataSourceImpl({required this.firestore, required this.storage});

  @override
  Future<UserProfileModel> getProfile(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserProfileModel.fromFirestore(doc);
      } else {
        throw ServerException('User not found');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

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

  @override
  Future<UserProfileModel> updateProfile(
    UserProfileModel profile, {
    File? image,
  }) async {
    try {
      String? imageUrl = profile.profileImageUrl;

      if (image != null) {
        final ref = storage.ref().child('user_images/${profile.id}.jpg');
        await ref.putFile(image);
        imageUrl = await ref.getDownloadURL();
      }

      final updatedProfile = profile.copyWith(profileImageUrl: imageUrl);

      await firestore
          .collection('users')
          .doc(profile.id)
          .set(updatedProfile.toFirestore(), SetOptions(merge: true));

      return updatedProfile;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
