import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technopalette_machine_test/core/error/failure.dart';
import 'package:technopalette_machine_test/domain/entities/user_profile.dart';
import 'package:technopalette_machine_test/domain/usecases/auth/login_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/auth/logout_usecase.dart';
import 'package:technopalette_machine_test/presentation/auth/bloc/auth_bloc.dart';
import 'package:technopalette_machine_test/presentation/auth/bloc/auth_event.dart';
import 'package:technopalette_machine_test/presentation/auth/bloc/auth_state.dart';
import '../mocks/mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeRegisterParams());
    registerFallbackValue(FakeResetPasswordParams());
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();

    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      logoutUseCase: mockLogoutUseCase,
      resetPasswordUseCase: mockResetPasswordUseCase,
    );
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

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when LoginRequested is added and login succeeds',
      build: () {
        when(
          () => mockLoginUseCase(any()),
        ).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const LoginRequested(email: tEmail, password: tPassword)),
      expect: () => [AuthLoading(), const AuthAuthenticated(user: tUser)],
      verify: (_) {
        verify(
          () => mockLoginUseCase(
            const LoginParams(email: tEmail, password: tPassword),
          ),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when LoginRequested is added and login fails',
      build: () {
        when(
          () => mockLoginUseCase(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const LoginRequested(email: tEmail, password: tPassword)),
      expect: () => [AuthLoading(), const AuthError(message: 'Server Error')],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when RegisterRequested is added and registration succeeds',
      build: () {
        when(
          () => mockRegisterUseCase(any()),
        ).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const RegisterRequested(
          email: tEmail,
          password: tPassword,
          name: tName,
        ),
      ),
      expect: () => [AuthLoading(), const AuthAuthenticated(user: tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when LogoutRequested is added and logout succeeds',
      build: () {
        when(
          () => mockLogoutUseCase(any()),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutRequested()),
      expect: () => [AuthLoading(), AuthUnauthenticated()],
    );
  });
}
