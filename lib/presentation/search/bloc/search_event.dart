import 'package:equatable/equatable.dart';
import '../../../domain/usecases/profile/search_profiles_usecase.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchRequested extends SearchEvent {
  final SearchProfilesParams filters;

  const SearchRequested(this.filters);

  @override
  List<Object?> get props => [filters];
}

class LoadCachedResultsRequested extends SearchEvent {
  final String query;

  const LoadCachedResultsRequested(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearchResultsRequested extends SearchEvent {}
