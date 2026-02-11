import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failure.dart';
import '../../entities/user_profile.dart';
import '../../repositories/search_repository.dart';

/// Use case for searching profiles with filtering
class SearchProfilesUseCase {
  final SearchRepository repository;

  SearchProfilesUseCase(this.repository);

  Future<Either<Failure, List<UserProfile>>> call(
    SearchProfilesParams params,
  ) async {
    // 1. Get results from repository (using name query)
    final result = await repository.searchProfiles(params.query);

    return result.map((users) {
      // 2. Filter logic in domain layer
      return users.where((user) {
        // Gender filter (opposite gender only)
        if (params.myGender != null) {
          if (user.gender == params.myGender) return false;
        }

        // Height filter
        if (params.minHeight != null && user.height != null) {
          if (user.height! < params.minHeight!) return false;
        }
        if (params.maxHeight != null && user.height != null) {
          if (user.height! > params.maxHeight!) return false;
        }

        // Weight filter
        if (params.minWeight != null && user.weight != null) {
          if (user.weight! < params.minWeight!) return false;
        }
        if (params.maxWeight != null && user.weight != null) {
          if (user.weight! > params.maxWeight!) return false;
        }

        // City filter (case-insensitive contains)
        if (params.city != null && params.city!.isNotEmpty) {
          if (user.city == null ||
              !user.city!.toLowerCase().contains(params.city!.toLowerCase())) {
            return false;
          }
        }

        // State filter (case-insensitive contains)
        if (params.state != null && params.state!.isNotEmpty) {
          if (user.state == null ||
              !user.state!.toLowerCase().contains(
                params.state!.toLowerCase(),
              )) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }
}

class SearchProfilesParams extends Equatable {
  final String query;
  final String? myGender;
  final double? minHeight;
  final double? maxHeight;
  final double? minWeight;
  final double? maxWeight;
  final String? city;
  final String? state;

  const SearchProfilesParams({
    required this.query,
    this.myGender,
    this.minHeight,
    this.maxHeight,
    this.minWeight,
    this.maxWeight,
    this.city,
    this.state,
  });

  @override
  List<Object?> get props => [
    query,
    myGender,
    minHeight,
    maxHeight,
    minWeight,
    maxWeight,
    city,
    state,
  ];
}
