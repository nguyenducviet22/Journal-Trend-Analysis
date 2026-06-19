import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class SyncRepository {
  Future<Either<Failure, void>> refreshAllData(String conceptId);
  Future<Either<Failure, DateTime?>> getLastSyncDate();
}
