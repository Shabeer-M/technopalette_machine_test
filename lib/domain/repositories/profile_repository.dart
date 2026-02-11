import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/user_profile.dart';
import 'dart:io';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getProfile(String userId);

  Future<Either<Failure, UserProfile>> updateProfile(
    UserProfile profile, {
    File? image,
  });

  Future<Either<Failure, List<UserProfile>>> searchProfiles(String query);
}
