import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/local/search_local_datasource.dart';
import '../datasources/remote/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<UserProfile>>> searchProfiles(
    String query,
  ) async {
    try {
      final remoteProfiles = await remoteDataSource.searchProfiles(query);
      await localDataSource.cacheSearchResults(query, remoteProfiles);
      return Right(remoteProfiles);
    } on ServerException catch (e) {
      try {
        final localProfiles = await localDataSource.getCachedSearchResults(
          query,
        );
        if (localProfiles.isNotEmpty) {
          return Right(localProfiles);
        }
        return Left(ServerFailure(e.message));
      } catch (_) {
        return Left(ServerFailure(e.message));
      }
    } catch (e) {
      try {
        final localProfiles = await localDataSource.getCachedSearchResults(
          query,
        );
        if (localProfiles.isNotEmpty) {
          return Right(localProfiles);
        }
        return Left(ServerFailure(e.toString()));
      } catch (_) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<UserProfile>>> getCachedResults(
    String query,
  ) async {
    try {
      final localProfiles = await localDataSource.getCachedSearchResults(query);
      return Right(localProfiles);
    } catch (e) {
      return Left(CacheFailure('No cached results found'));
    }
  }
}
