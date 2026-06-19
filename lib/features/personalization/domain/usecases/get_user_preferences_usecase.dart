import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_preferences.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetUserPreferencesUseCase implements UseCase<UserPreferences, NoParams> {
  final UserRepository _repository;

  GetUserPreferencesUseCase(this._repository);

  @override
  Future<Either<Failure, UserPreferences>> call(NoParams params) {
    return _repository.getUserPreferences();
  }
}
