import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<String>>> getRecentSearches();
  Future<Either<Failure, void>> saveSearchQuery(String query);
  Future<Either<Failure, void>> clearRecentSearches();
}
