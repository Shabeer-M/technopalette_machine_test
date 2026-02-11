import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failure.dart';
import '../../entities/user_profile.dart';
import '../../repositories/search_repository.dart';

/// Use case to get cached search results
class GetCachedSearchResultsUseCase {
  final SearchRepository repository;

  GetCachedSearchResultsUseCase(this.repository);

  Future<Either<Failure, List<UserProfile>>> call(
    GetCachedSearchResultsParams params,
  ) async {
    return await repository.getCachedResults(params.query);
  }
}

class GetCachedSearchResultsParams extends Equatable {
  final String query;

  const GetCachedSearchResultsParams({required this.query});

  @override
  List<Object?> get props => [query];
}
