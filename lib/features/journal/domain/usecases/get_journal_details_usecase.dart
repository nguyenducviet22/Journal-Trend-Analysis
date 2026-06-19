import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

@lazySingleton
class GetJournalDetailsUseCase implements UseCase<Journal, String> {
  final JournalRepository _repository;

  GetJournalDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, Journal>> call(String params) {
    return _repository.getJournalDetails(params);
  }
}
