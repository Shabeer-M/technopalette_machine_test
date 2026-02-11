import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failure.dart';
import '../../entities/user_profile.dart';
import '../../repositories/profile_repository.dart';

/// Use case for getting a profile
class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserProfile>> call(GetProfileParams params) async {
    return await repository.getProfile(params.userId);
  }
}

class GetProfileParams extends Equatable {
  final String userId;

  const GetProfileParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
