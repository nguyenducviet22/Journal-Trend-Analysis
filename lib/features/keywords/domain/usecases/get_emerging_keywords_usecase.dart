import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/keyword.dart';
import '../repositories/keyword_repository.dart';

@lazySingleton
class GetEmergingKeywordsUseCase implements UseCase<List<Keyword>, String> {
  final KeywordRepository _repository;

  GetEmergingKeywordsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Keyword>>> call(String params) {
    return _repository.getEmergingKeywords(params);
  }
}
