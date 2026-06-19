import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/paper.dart';
import '../repositories/publication_repository.dart';

@lazySingleton
class GetPublicationDetailsUseCase implements UseCase<Paper, String> {
  final PublicationRepository _repository;

  GetPublicationDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, Paper>> call(String params) {
    return _repository.getPaperDetails(params);
  }
}
