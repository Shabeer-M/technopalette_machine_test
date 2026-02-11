import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../entities/user_profile.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserProfile>> login(String email, String password);

  Future<Either<Failure, UserProfile>> register(
    String email,
    String password,
    String name,
  );

  Future<Either<Failure, void>> resetPassword(String email);

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserProfile>> getCurrentUser();
}
