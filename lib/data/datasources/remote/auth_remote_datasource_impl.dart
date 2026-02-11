import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/error/exceptions.dart';
import '../../models/user_profile_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserProfileModel> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      return UserProfileModel.fromFirebaseUser(user);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<UserProfileModel> login(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final userDoc = await firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          final userModel = UserProfileModel.fromFirebaseUser(user);
          await firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toFirestore());
        }

        return UserProfileModel.fromFirebaseUser(user);
      } else {
        throw ServerException('User not found after login');
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Login failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserProfileModel> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
        final updatedUser = firebaseAuth.currentUser;
        final userModel = UserProfileModel.fromFirebaseUser(
          updatedUser!,
          name: name,
        );

        await firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toFirestore());

        return userModel;
      } else {
        throw ServerException('User creation failed');
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Registration failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Password reset failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
