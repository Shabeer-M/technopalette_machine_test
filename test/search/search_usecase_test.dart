import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technopalette_machine_test/core/error/failure.dart';
import 'package:technopalette_machine_test/domain/entities/user_profile.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/get_cached_search_results_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/search_profiles_usecase.dart';
import '../mocks/mocks.dart';

void main() {
  late MockSearchRepository mockSearchRepository;
  late SearchProfilesUseCase searchProfilesUseCase;
  late GetCachedSearchResultsUseCase getCachedSearchResultsUseCase;

  setUpAll(() {
    registerFallbackValue(FakeSearchProfilesParams());
  });

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    searchProfilesUseCase = SearchProfilesUseCase(mockSearchRepository);
    getCachedSearchResultsUseCase = GetCachedSearchResultsUseCase(
      mockSearchRepository,
    );
  });

  const tQuery = 'test';
  const tFilters = SearchProfilesParams(query: tQuery);
  final tUsers = [
    const UserProfile(
      id: '1',
      email: 'user1@example.com',
      name: 'User One',
      gender: 'Bride',
    ),
    const UserProfile(
      id: '2',
      email: 'user2@example.com',
      name: 'User Two',
      gender: 'Bride',
    ),
  ];

  group('SearchProfilesUseCase', () {
    test(
      'should get list of profiles from repository based on filters',
      () async {
        // arrange
        when(
          () => mockSearchRepository.searchProfiles(tQuery),
        ).thenAnswer((_) async => Right(tUsers));

        // act
        final result = await searchProfilesUseCase(tFilters);

        // assert
        result.fold(
          (failure) => fail('Expected Right but got Left: $failure'),
          (users) => expect(users, tUsers),
        );
        verify(() => mockSearchRepository.searchProfiles(tQuery));
        verifyNoMoreInteractions(mockSearchRepository);
      },
    );
  });

  group('GetCachedSearchResultsUseCase', () {
    test('should get cached profiles from repository', () async {
      // arrange
      when(
        () => mockSearchRepository.getCachedResults(tQuery),
      ).thenAnswer((_) async => Right(tUsers));

      // act
      final result = await getCachedSearchResultsUseCase(
        const GetCachedSearchResultsParams(query: tQuery),
      );

      // assert
      expect(result, Right<Failure, List<UserProfile>>(tUsers));
      verify(() => mockSearchRepository.getCachedResults(tQuery));
      verifyNoMoreInteractions(mockSearchRepository);
    });
  });
}
