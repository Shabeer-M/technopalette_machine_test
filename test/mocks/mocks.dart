import 'package:mocktail/mocktail.dart';
import 'package:technopalette_machine_test/domain/repositories/auth_repository.dart';
import 'package:technopalette_machine_test/domain/repositories/profile_repository.dart';
import 'package:technopalette_machine_test/domain/repositories/search_repository.dart';
import 'package:technopalette_machine_test/domain/usecases/auth/login_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/auth/logout_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/auth/register_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/auth/reset_password_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/get_profile_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/search_profiles_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/get_cached_search_results_usecase.dart';
import 'package:technopalette_machine_test/domain/usecases/profile/update_profile_usecase.dart';
import 'package:technopalette_machine_test/data/datasources/remote/auth_remote_datasource.dart';
import 'package:technopalette_machine_test/data/datasources/remote/profile_remote_datasource.dart';
import 'package:technopalette_machine_test/data/datasources/remote/search_remote_datasource.dart';
import 'package:technopalette_machine_test/data/datasources/local/profile_local_datasource.dart';
import 'package:technopalette_machine_test/data/datasources/local/search_local_datasource.dart';
import 'package:technopalette_machine_test/core/storage/local_storage_repository.dart';
import 'package:technopalette_machine_test/domain/entities/user_profile.dart'; // Needed for Fakes

// Domain - Repositories
class MockAuthRepository extends Mock implements AuthRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockSearchRepository extends Mock implements SearchRepository {}

// Domain - Use Cases
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockResetPasswordUseCase extends Mock implements ResetPasswordUseCase {}

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

class MockSearchProfilesUseCase extends Mock implements SearchProfilesUseCase {}

class MockGetCachedSearchResultsUseCase extends Mock
    implements GetCachedSearchResultsUseCase {}

// Data - Data Sources
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockSearchRemoteDataSource extends Mock
    implements SearchRemoteDataSource {}

class MockProfileLocalDataSource extends Mock
    implements ProfileLocalDataSource {}

class MockSearchLocalDataSource extends Mock implements SearchLocalDataSource {}

// Core
class MockLocalStorageRepository extends Mock
    implements LocalStorageRepository {}

// Fakes
class FakeUserProfile extends Fake implements UserProfile {}

class FakeLoginParams extends Fake implements LoginParams {}

class FakeRegisterParams extends Fake implements RegisterParams {}

class FakeResetPasswordParams extends Fake implements ResetPasswordParams {}

class FakeUpdateProfileParams extends Fake implements UpdateProfileParams {}

class FakeSearchProfilesParams extends Fake implements SearchProfilesParams {}
