import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technopalette_machine_test/domain/usecases/auth/login_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/auth/register_usecase.dart';
import 'package:technopalette_machine_test/domain/entities/user_profile.dart';
import '../mocks/mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase loginUseCase;
  late RegisterUseCase registerUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
    registerUseCase = RegisterUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tName = 'Test User';
  const tUser = UserProfile(
    id: '123',
    email: tEmail,
    name: tName,
    gender: 'Bride',
  );

  group('LoginUseCase', () {
    test(
      'should call authRepository.login and return UserProfile on success',
      () async {
        // arrange
        when(
          () => mockAuthRepository.login(tEmail, tPassword),
        ).thenAnswer((_) async => const Right(tUser));

        // act
        final result = await loginUseCase(
          const LoginParams(email: tEmail, password: tPassword),
        );

        // assert
        expect(result, const Right(tUser));
        verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });

  group('RegisterUseCase', () {
    test(
      'should call authRepository.register and return UserProfile on success',
      () async {
        // arrange
        when(
          () => mockAuthRepository.register(tEmail, tPassword, tName),
        ).thenAnswer((_) async => const Right(tUser));

        // act
        final result = await registerUseCase(
          const RegisterParams(email: tEmail, password: tPassword, name: tName),
        );

        // assert
        expect(result, const Right(tUser));
        verify(
          () => mockAuthRepository.register(tEmail, tPassword, tName),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}
