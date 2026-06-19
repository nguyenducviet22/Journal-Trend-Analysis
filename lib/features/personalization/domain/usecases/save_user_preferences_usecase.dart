import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_preferences.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class SaveUserPreferencesUseCase implements UseCase<void, UserPreferences> {
  final UserRepository _repository;

  SaveUserPreferencesUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(UserPreferences params) {
    return _repository.saveUserPreferences(params);
  }
}
