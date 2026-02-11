import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technopalette_machine_test/data/repositories/auth_repository_impl.dart';
import 'package:technopalette_machine_test/domain/entities/user_profile.dart';
import 'package:technopalette_machine_test/core/error/failure.dart';
import 'package:technopalette_machine_test/core/error/exceptions.dart';
import 'package:technopalette_machine_test/data/models/user_profile_model.dart';
import '../mocks/mocks.dart';

void main() {
  late AuthRepositoryImpl authRepository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockLocalStorageRepository mockLocalStorageRepository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalStorageRepository = MockLocalStorageRepository();
    authRepository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localStorageRepository: mockLocalStorageRepository,
    );
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tName = 'Test User';
  const tUserModel = UserProfileModel(
    id: '123',
    email: tEmail,
    name: tName,
    gender: 'Bride',
  );
  const UserProfile tUser = tUserModel;

  group('login', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.login(tEmail, tPassword),
        ).thenAnswer((_) async => tUserModel);
        when(
          () => mockLocalStorageRepository.saveString(any(), any()),
        ).thenAnswer((_) async => {});

        // act
        final result = await authRepository.login(tEmail, tPassword);

        // assert
        verify(() => mockRemoteDataSource.login(tEmail, tPassword));
        expect(result, equals(const Right(tUser)));
        verify(
          () => mockLocalStorageRepository.saveString('user_id', tUserModel.id),
        );
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.login(tEmail, tPassword),
        ).thenThrow(ServerException('Server Error'));

        // act
        final result = await authRepository.login(tEmail, tPassword);

        // assert
        verify(() => mockRemoteDataSource.login(tEmail, tPassword));
        expect(result, equals(Left(ServerFailure('Server Error'))));
        verifyZeroInteractions(mockLocalStorageRepository);
      },
    );
  });

  group('register', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.register(tEmail, tPassword, tName),
        ).thenAnswer((_) async => tUserModel);
        when(
          () => mockLocalStorageRepository.saveString(any(), any()),
        ).thenAnswer((_) async => {});

        // act
        final result = await authRepository.register(tEmail, tPassword, tName);

        // assert
        verify(() => mockRemoteDataSource.register(tEmail, tPassword, tName));
        expect(result, equals(const Right(tUser)));
        verify(
          () => mockLocalStorageRepository.saveString('user_id', tUserModel.id),
        );
      },
    );
  });

  group('logout', () {
    test(
      'should call logout on remote data source and clear local storage',
      () async {
        // arrange
        when(() => mockRemoteDataSource.logout()).thenAnswer((_) async => {});
        when(
          () => mockLocalStorageRepository.delete(any()),
        ).thenAnswer((_) async => {});

        // act
        final result = await authRepository.logout();

        // assert
        verify(() => mockRemoteDataSource.logout());
        verify(() => mockLocalStorageRepository.delete('user_id'));
        expect(result, equals(const Right(null)));
      },
    );
  });
}
