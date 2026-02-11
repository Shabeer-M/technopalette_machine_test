import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/get_profile_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/update_profile_usecase.dart';
import 'package:technopalette_machine_test/domain/entities/user_profile.dart';
import '../mocks/mocks.dart';

void main() {
  late MockProfileRepository mockProfileRepository;
  late GetProfileUseCase getProfileUseCase;
  late UpdateProfileUseCase updateProfileUseCase;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    getProfileUseCase = GetProfileUseCase(mockProfileRepository);
    updateProfileUseCase = UpdateProfileUseCase(mockProfileRepository);
  });

  const tUserId = '123';
  const tUser = UserProfile(
    id: tUserId,
    email: 'test@example.com',
    name: 'Test User',
    gender: 'Bride',
  );

  group('GetProfileUseCase', () {
    test('should get user profile from the repository', () async {
      // arrange
      when(
        () => mockProfileRepository.getProfile(tUserId),
      ).thenAnswer((_) async => const Right(tUser));

      // act
      final result = await getProfileUseCase(
        const GetProfileParams(userId: tUserId),
      );

      // assert
      expect(result, const Right(tUser));
      verify(() => mockProfileRepository.getProfile(tUserId));
      verifyNoMoreInteractions(mockProfileRepository);
    });
  });

  group('UpdateProfileUseCase', () {
    test('should update user profile via repository', () async {
      // arrange
      when(
        () => mockProfileRepository.updateProfile(tUser),
      ).thenAnswer((_) async => const Right(tUser));

      // act
      final result = await updateProfileUseCase(
        const UpdateProfileParams(profile: tUser),
      );

      // assert
      expect(result, const Right(tUser));
      verify(() => mockProfileRepository.updateProfile(tUser));
      verifyNoMoreInteractions(mockProfileRepository);
    });
  });
}
