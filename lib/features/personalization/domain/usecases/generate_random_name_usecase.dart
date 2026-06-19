import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GenerateRandomNameUseCase implements UseCase<String, NoParams> {
  final UserRepository _repository;

  GenerateRandomNameUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return _repository.generateRandomName();
  }
}
