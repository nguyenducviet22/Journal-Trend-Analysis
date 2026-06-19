import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/search_repository.dart';

@lazySingleton
class GetRecentSearchesUseCase implements UseCase<List<String>, NoParams> {
  final SearchRepository _repository;

  GetRecentSearchesUseCase(this._repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return _repository.getRecentSearches();
  }
}
