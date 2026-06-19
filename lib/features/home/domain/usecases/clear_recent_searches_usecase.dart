import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_repository.dart';

@lazySingleton
class ClearRecentSearchesUseCase implements UseCase<void, NoParams> {
  final SearchRepository _repository;

  ClearRecentSearchesUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.clearRecentSearches();
  }
}
