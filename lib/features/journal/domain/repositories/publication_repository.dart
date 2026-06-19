import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/paper.dart';

abstract class PublicationRepository {
  Future<Either<Failure, List<Paper>>> getPapersForTopic(
    String conceptId, {
    int page = 1,
    String? searchQuery,
  });
  Future<Either<Failure, Paper>> getPaperDetails(String paperId);
  Future<Either<Failure, String>> getTopJournalName(String conceptId);
  Future<Either<Failure, Paper?>> getMostInfluentialPaper(String conceptId);
}
