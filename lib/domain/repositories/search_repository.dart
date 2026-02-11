import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/user_profile.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<UserProfile>>> searchProfiles(String query);
  Future<Either<Failure, List<UserProfile>>> getCachedResults(String query);
}
