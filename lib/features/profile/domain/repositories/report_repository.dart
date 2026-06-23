import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class ReportRepository {
  Future<Either<Failure, String>> generateAndUploadReport({
    required String conceptName,
    required String fullName,
    required int totalPublications,
    required double avgCitations,
    required int totalCitations,
    required int activeYear,
    required String topJournal,
    required String topAuthor,
  });
}
