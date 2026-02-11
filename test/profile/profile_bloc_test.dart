import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technopalette_machine_test/core/error/failure.dart';
import 'package:technopalette_machine_test/domain/entities/user_profile.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/get_profile_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/update_profile_usecase.dart';
import 'package:technopalette_machine_test/presentation/profile/bloc/profile_bloc.dart';
import 'package:technopalette_machine_test/presentation/profile/bloc/profile_event.dart';
import 'package:technopalette_machine_test/presentation/profile/bloc/profile_state.dart';
import '../mocks/mocks.dart';

void main() {
  late ProfileBloc profileBloc;
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;

  setUpAll(() {
    registerFallbackValue(FakeUpdateProfileParams());
    registerFallbackValue(const GetProfileParams(userId: 'dummy'));
  });

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();

    profileBloc = ProfileBloc(
      getProfileUseCase: mockGetProfileUseCase,
      updateProfileUseCase: mockUpdateProfileUseCase,
    );
  });

  const tUserId = '123';
  const tUser = UserProfile(
    id: tUserId,
    email: 'test@example.com',
    name: 'Test User',
    gender: 'Bride',
  );

  group('ProfileBloc', () {
    test('initial state should be ProfileInitial', () {
      expect(profileBloc.state, equals(ProfileInitial()));
    });

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when LoadProfileRequested is added and success',
      build: () {
        when(
          () => mockGetProfileUseCase(any()),
        ).thenAnswer((_) async => const Right(tUser));
        return profileBloc;
      },
      act: (bloc) => bloc.add(const LoadProfileRequested(tUserId)),
      expect: () => [ProfileLoading(), const ProfileLoaded(tUser)],
      verify: (_) {
        verify(
          () => mockGetProfileUseCase(const GetProfileParams(userId: tUserId)),
        ).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when LoadProfileRequested varies and fails',
      build: () {
        when(
          () => mockGetProfileUseCase(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return profileBloc;
      },
      act: (bloc) => bloc.add(const LoadProfileRequested(tUserId)),
      expect: () => [ProfileLoading(), const ProfileError('Server Error')],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileUpdated] when UpdateProfileRequested is added and success',
      build: () {
        when(
          () => mockUpdateProfileUseCase(any()),
        ).thenAnswer((_) async => const Right(tUser));
        return profileBloc;
      },
      act: (bloc) => bloc.add(const UpdateProfileRequested(tUser)),
      expect: () => [ProfileLoading(), const ProfileUpdated(tUser)],
      verify: (_) {
        verify(
          () => mockUpdateProfileUseCase(
            const UpdateProfileParams(profile: tUser),
          ),
        ).called(1);
      },
    );
  });
}
