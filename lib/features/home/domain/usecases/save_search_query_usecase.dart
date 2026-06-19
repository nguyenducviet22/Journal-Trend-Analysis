import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_repository.dart';

@lazySingleton
class SaveSearchQueryUseCase implements UseCase<void, String> {
  final SearchRepository _repository;

  SaveSearchQueryUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return _repository.saveSearchQuery(params);
  }
}
