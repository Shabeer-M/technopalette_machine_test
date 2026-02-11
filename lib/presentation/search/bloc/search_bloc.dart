import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/profile/get_cached_search_results_usecase.dart';
import '../../../domain/usecases/profile/search_profiles_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProfilesUseCase searchProfilesUseCase;
  final GetCachedSearchResultsUseCase getCachedSearchResultsUseCase;

  SearchBloc({
    required this.searchProfilesUseCase,
    required this.getCachedSearchResultsUseCase,
  }) : super(SearchInitial()) {
    on<SearchRequested>(_onSearchRequested);
    on<LoadCachedResultsRequested>(_onLoadCachedResultsRequested);
    on<ClearSearchResultsRequested>(_onClearSearchResultsRequested);
  }

  Future<void> _onSearchRequested(
    SearchRequested event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    final result = await searchProfilesUseCase(event.filters);

    result.fold((failure) => emit(SearchError(failure.message)), (users) {
      if (users.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(users));
      }
    });
  }

  Future<void> _onLoadCachedResultsRequested(
    LoadCachedResultsRequested event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    final result = await getCachedSearchResultsUseCase(
      GetCachedSearchResultsParams(query: event.query),
    );

    result.fold((failure) => emit(SearchError(failure.message)), (users) {
      if (users.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(users));
      }
    });
  }

  void _onClearSearchResultsRequested(
    ClearSearchResultsRequested event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitial());
  }
}
