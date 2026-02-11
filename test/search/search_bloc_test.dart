import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:technopalette_machine_test/core/error/failure.dart';
import 'package:technopalette_machine_test/domain/entities/user_profile.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/get_cached_search_results_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/search_profiles_usecase.dart';
import 'package:technopalette_machine_test/presentation/search/bloc/search_bloc.dart';
import 'package:technopalette_machine_test/presentation/search/bloc/search_event.dart';
import 'package:technopalette_machine_test/presentation/search/bloc/search_state.dart';
import '../mocks/mocks.dart';

void main() {
  late SearchBloc searchBloc;
  late MockSearchProfilesUseCase mockSearchProfilesUseCase;
  late MockGetCachedSearchResultsUseCase mockGetCachedSearchResultsUseCase;

  setUpAll(() {
    registerFallbackValue(FakeSearchProfilesParams());
    registerFallbackValue(FakeGetCachedSearchResultsParams());
  });

  setUp(() {
    mockSearchProfilesUseCase = MockSearchProfilesUseCase();
    mockGetCachedSearchResultsUseCase = MockGetCachedSearchResultsUseCase();

    searchBloc = SearchBloc(
      searchProfilesUseCase: mockSearchProfilesUseCase,
      getCachedSearchResultsUseCase: mockGetCachedSearchResultsUseCase,
    );
  });

  const tFilters = SearchProfilesParams(query: 'test');
  const tQuery = 'test';
  const tUser = UserProfile(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    gender: 'Bride',
  );
  final tUsers = [tUser];

  group('SearchBloc', () {
    test('initial state should be SearchInitial', () {
      expect(searchBloc.state, equals(SearchInitial()));
    });

    // SearchRequested
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchLoaded] when SearchRequested is added and success',
      build: () {
        when(
          () => mockSearchProfilesUseCase(any()),
        ).thenAnswer((_) async => Right(tUsers));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchRequested(tFilters)),
      expect: () => [SearchLoading(), SearchLoaded(tUsers)],
      verify: (_) {
        verify(() => mockSearchProfilesUseCase(tFilters)).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchEmpty] when SearchRequested is added and no results',
      build: () {
        when(
          () => mockSearchProfilesUseCase(any()),
        ).thenAnswer((_) async => const Right([]));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchRequested(tFilters)),
      expect: () => [SearchLoading(), SearchEmpty()],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchError] when SearchRequested is added and fails',
      build: () {
        when(
          () => mockSearchProfilesUseCase(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Error')));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchRequested(tFilters)),
      expect: () => [SearchLoading(), const SearchError('Server Error')],
    );

    // LoadCachedResultsRequested
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchLoaded] when LoadCachedResultsRequested is added and success',
      build: () {
        when(
          () => mockGetCachedSearchResultsUseCase(any()),
        ).thenAnswer((_) async => Right(tUsers));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const LoadCachedResultsRequested(tQuery)),
      expect: () => [SearchLoading(), SearchLoaded(tUsers)],
    );
  });
}

class FakeGetCachedSearchResultsParams extends Fake
    implements GetCachedSearchResultsParams {}
