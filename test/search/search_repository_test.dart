import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technopalette_machine_test/data/repositories/search_repository_impl.dart';
import 'package:technopalette_machine_test/domain/entities/user_profile.dart';
import 'package:technopalette_machine_test/core/error/exceptions.dart';
import 'package:technopalette_machine_test/core/error/failure.dart';
import 'package:technopalette_machine_test/data/models/user_profile_model.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/search_profiles_usecase.dart';
import '../mocks/mocks.dart';

void main() {
  late SearchRepositoryImpl searchRepository;
  late MockSearchRemoteDataSource mockRemoteDataSource;
  late MockSearchLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(FakeSearchProfilesParams());
  });

  setUp(() {
    mockRemoteDataSource = MockSearchRemoteDataSource();
    mockLocalDataSource = MockSearchLocalDataSource();
    searchRepository = SearchRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tQuery = 'test';
  final tUserModels = [
    const UserProfileModel(
      id: '1',
      email: 'user1@example.com',
      name: 'User One',
      gender: 'Bride',
    ),
    const UserProfileModel(
      id: '2',
      email: 'user2@example.com',
      name: 'User Two',
      gender: 'Bride',
    ),
  ];
  final List<UserProfile> tUsers = tUserModels;

  group('searchProfiles', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.searchProfiles(tQuery),
        ).thenAnswer((_) async => tUserModels);
        when(
          () => mockLocalDataSource.cacheSearchResults(any(), any()),
        ).thenAnswer((_) async => {});

        // act
        final result = await searchRepository.searchProfiles(tQuery);

        // assert
        verify(() => mockRemoteDataSource.searchProfiles(tQuery));
        expect(result, equals(Right(tUsers)));
        verify(
          () => mockLocalDataSource.cacheSearchResults(tQuery, tUserModels),
        );
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.searchProfiles(tQuery),
        ).thenThrow(ServerException('Server Error'));
        when(
          () => mockLocalDataSource.getCachedSearchResults(tQuery),
        ).thenAnswer((_) async => []);

        // act
        final result = await searchRepository.searchProfiles(tQuery);

        // assert
        verify(() => mockRemoteDataSource.searchProfiles(tQuery));
        // Expect checking local cache
        verify(() => mockLocalDataSource.getCachedSearchResults(tQuery));
        expect(result, equals(Left(ServerFailure('Server Error'))));
      },
    );
  });

  group('getCachedResults', () {
    test('should return cached data when available', () async {
      // arrange
      when(
        () => mockLocalDataSource.getCachedSearchResults(tQuery),
      ).thenAnswer((_) async => tUserModels);

      // act
      final result = await searchRepository.getCachedResults(tQuery);

      // assert
      verify(() => mockLocalDataSource.getCachedSearchResults(tQuery));
      expect(result, equals(Right(tUsers)));
    });

    test('should return CacheFailure when no cached data is found', () async {
      // arrange
      when(() => mockLocalDataSource.getCachedSearchResults(tQuery)).thenAnswer(
        (_) async => [],
      ); // Or throws exception? Let's assume empty list maps to empty or failure?
      // Wait, SearchLocalDataSource returns List<UserProfileModel>.
      // If empty, repo might return empty list.
      // If exception:
      when(
        () => mockLocalDataSource.getCachedSearchResults(tQuery),
      ).thenThrow(CacheException());

      // act
      final result = await searchRepository.getCachedResults(tQuery);

      // assert
      verify(() => mockLocalDataSource.getCachedSearchResults(tQuery));
      expect(result, equals(Left(CacheFailure('No cached results found'))));
    });
  });
}
