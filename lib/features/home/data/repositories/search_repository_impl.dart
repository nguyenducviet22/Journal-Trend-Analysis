import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_data_source.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  final SearchLocalDataSource _localDataSource;

  SearchRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<String>>> getRecentSearches() async {
    try {
      final list = await _localDataSource.getRecentSearches();
      return Right(list);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Cache error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> saveSearchQuery(String query) async {
    try {
      await _localDataSource.saveSearchQuery(query);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Cache error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> clearRecentSearches() async {
    try {
      await _localDataSource.clearRecentSearches();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Cache error occurred.'));
    }
  }
}
