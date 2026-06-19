import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trend.dart';
import '../repositories/keyword_repository.dart';

@lazySingleton
class GetCitationTrendsUseCase implements UseCase<List<CitationTrend>, String> {
  final KeywordRepository _repository;

  GetCitationTrendsUseCase(this._repository);

  @override
  Future<Either<Failure, List<CitationTrend>>> call(String params) {
    return _repository.getCitationTrends(params);
  }
}
