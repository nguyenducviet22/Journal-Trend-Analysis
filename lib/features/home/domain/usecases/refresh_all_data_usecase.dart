import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/sync_repository.dart';

@lazySingleton
class RefreshAllDataUseCase implements UseCase<void, String> {
  final SyncRepository _repository;

  RefreshAllDataUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return _repository.refreshAllData(params);
  }
}
