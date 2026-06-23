import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/report_repository.dart';
import 'report_state.dart';

@injectable
class ReportCubit extends Cubit<ReportState> {
  final ReportRepository _reportRepository;

  ReportCubit(this._reportRepository) : super(ReportInitial());

  Future<void> exportReport({
    required String conceptName,
    required String fullName,
    required int totalPublications,
    required double avgCitations,
    required int totalCitations,
    required int activeYear,
    required String topJournal,
    required String topAuthor,
  }) async {
    emit(ReportGenerating());
    
    emit(ReportUploading());

    final result = await _reportRepository.generateAndUploadReport(
      conceptName: conceptName,
      fullName: fullName,
      totalPublications: totalPublications,
      avgCitations: avgCitations,
      totalCitations: totalCitations,
      activeYear: activeYear,
      topJournal: topJournal,
      topAuthor: topAuthor,
    );

    result.fold(
      (failure) => emit(ReportFailure(failure.message)),
      (url) => emit(ReportUploadSuccess(url)),
    );
  }
}
