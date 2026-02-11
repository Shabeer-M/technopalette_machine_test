import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/local/profile_local_datasource.dart';
import '../datasources/remote/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserProfile>> getProfile(String userId) async {
    try {
      final remoteProfile = await remoteDataSource.getProfile(userId);
      await localDataSource.cacheProfile(remoteProfile);
      return Right(remoteProfile);
    } on ServerException catch (e) {
      try {
        final localProfile = await localDataSource.getCachedProfile(userId);
        if (localProfile != null) {
          return Right(localProfile);
        }
        return Left(ServerFailure(e.message));
      } catch (_) {
        return Left(ServerFailure(e.message));
      }
    } catch (e) {
      try {
        final localProfile = await localDataSource.getCachedProfile(userId);
        if (localProfile != null) {
          return Right(localProfile);
        }
        return Left(ServerFailure(e.toString()));
      } catch (_) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> searchProfiles(
    String query,
  ) async {
    try {
      final users = await remoteDataSource.searchProfiles(query);
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    UserProfile profile, {
    File? image,
  }) async {
    try {
      final userModel = UserProfileModel(
        id: profile.id,
        email: profile.email,
        name: profile.name,
        gender: profile.gender,
        profileImageUrl: profile.profileImageUrl,
        height: profile.height,
        weight: profile.weight,
        address: profile.address,
        city: profile.city,
        state: profile.state,
        familyInfo: profile.familyInfo,
      );

      final updatedUser = await remoteDataSource.updateProfile(
        userModel,
        image: image,
      );

      await localDataSource.cacheProfile(updatedUser);

      return Right(updatedUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
