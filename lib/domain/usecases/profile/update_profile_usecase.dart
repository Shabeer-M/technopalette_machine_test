import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failure.dart';
import '../../entities/user_profile.dart';
import '../../repositories/profile_repository.dart';

/// Use case for updating a profile
class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(params.profile, image: params.image);
  }
}

class UpdateProfileParams extends Equatable {
  final UserProfile profile;
  final File? image;

  const UpdateProfileParams({required this.profile, this.image});

  @override
  List<Object?> get props => [profile, image];
}
