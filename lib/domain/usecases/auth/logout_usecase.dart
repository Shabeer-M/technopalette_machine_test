import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failure.dart';
import '../../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
