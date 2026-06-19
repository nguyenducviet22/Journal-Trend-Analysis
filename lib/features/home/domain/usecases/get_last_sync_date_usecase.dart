import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/sync_repository.dart';

@lazySingleton
class GetLastSyncDateUseCase implements UseCase<DateTime?, NoParams> {
  final SyncRepository _repository;

  GetLastSyncDateUseCase(this._repository);

  @override
  Future<Either<Failure, DateTime?>> call(NoParams params) {
    return _repository.getLastSyncDate();
  }
}
