import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technopalette_machine_test/data/repositories/profile_repository_impl.dart';
import 'package:technopalette_machine_test/domain/entities/user_profile.dart';
import 'package:technopalette_machine_test/core/error/failure.dart';
import 'package:technopalette_machine_test/core/error/exceptions.dart';
import 'package:technopalette_machine_test/data/models/user_profile_model.dart';
import '../mocks/mocks.dart';

void main() {
  late ProfileRepositoryImpl profileRepository;
  late MockProfileRemoteDataSource mockRemoteDataSource;
  late MockProfileLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(
      const UserProfileModel(
        id: 'fallback',
        email: 'fallback',
        name: 'fallback',
        gender: 'fallback',
      ),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    mockLocalDataSource = MockProfileLocalDataSource();
    profileRepository = ProfileRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tUserId = '123';
  const tUserModel = UserProfileModel(
    id: tUserId,
    email: 'test@example.com',
    name: 'Test User',
    gender: 'Bride',
  );
  const UserProfile tUser = tUserModel;

  group('getProfile', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getProfile(tUserId),
        ).thenAnswer((_) async => tUserModel);
        when(
          () => mockLocalDataSource.cacheProfile(tUserModel),
        ).thenAnswer((_) async => {});

        // act
        final result = await profileRepository.getProfile(tUserId);

        // assert
        verify(() => mockRemoteDataSource.getProfile(tUserId));
        expect(result, equals(const Right(tUser)));
        verify(() => mockLocalDataSource.cacheProfile(tUserModel));
      },
    );

    test(
      'should return local data when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getProfile(tUserId),
        ).thenThrow(ServerException('Server Error'));
        when(
          () => mockLocalDataSource.getCachedProfile(tUserId),
        ).thenAnswer((_) async => tUserModel);

        // act
        final result = await profileRepository.getProfile(tUserId);

        // assert
        verify(() => mockRemoteDataSource.getProfile(tUserId));
        verify(() => mockLocalDataSource.getCachedProfile(tUserId));
        expect(result, equals(const Right(tUser)));
      },
    );

    test(
      'should return ServerFailure when both remote and local calls fail',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getProfile(tUserId),
        ).thenThrow(ServerException('Server Error'));
        when(
          () => mockLocalDataSource.getCachedProfile(tUserId),
        ).thenThrow(CacheException());

        // act
        final result = await profileRepository.getProfile(tUserId);

        // assert
        expect(result, equals(Left(ServerFailure('Server Error'))));
      },
    );
  });

  group('updateProfile', () {
    test(
      'should return updated data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.updateProfile(
            any(),
            image: any(named: 'image'),
          ),
        ).thenAnswer((_) async => tUserModel);
        when(
          () => mockLocalDataSource.cacheProfile(tUserModel),
        ).thenAnswer((_) async => {});

        // act
        final result = await profileRepository.updateProfile(tUserModel);

        // assert
        verify(
          () => mockRemoteDataSource.updateProfile(
            any(),
            image: any(named: 'image'),
          ),
        );
        expect(result, equals(const Right(tUser)));
        verify(() => mockLocalDataSource.cacheProfile(tUserModel));
      },
    );
  });
}
