import 'package:injectable/injectable.dart';
import '../../../../core/network/api_client.dart';
import '../models/paper_model.dart';
import '../models/journal_model.dart';

abstract class JournalRemoteDataSource {
  Future<List<PaperModel>> getPapersForTopic(
    String conceptId, {
    int page = 1,
    String? searchQuery,
  });
  Future<PaperModel> getPaperDetails(String paperId);
  Future<List<JournalModel>> getTopJournals(String conceptId);
  Future<JournalModel> getJournalDetails(String journalId);
  Future<String> getTopJournalName(String conceptId);
  Future<PaperModel?> getMostInfluentialPaper(String conceptId);
}

@LazySingleton(as: JournalRemoteDataSource)
class JournalRemoteDataSourceImpl implements JournalRemoteDataSource {
  final ApiClient _apiClient;

  JournalRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<PaperModel>> getPapersForTopic(
    String conceptId, {
    int page = 1,
    String? searchQuery,
  }) async {
    final queryParams = <String, dynamic>{
      'filter': 'concepts.id:$conceptId',
      'page': page,
      'per_page': 20,
    };
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      queryParams['search'] = searchQuery;
    }

    final response = await _apiClient.get('/works', queryParameters: queryParams);
    final results = response['results'] as List<dynamic>? ?? [];
    return results
        .map((json) => PaperModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PaperModel> getPaperDetails(String paperId) async {
    final response = await _apiClient.get('/works/$paperId');
    return PaperModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<List<JournalModel>> getTopJournals(String conceptId) async {
    final queryParams = <String, dynamic>{
      'filter': 'concepts.id:$conceptId',
      'sort': 'works_count:desc',
      'per_page': 10,
    };

    final response = await _apiClient.get('/sources', queryParameters: queryParams);
    final results = response['results'] as List<dynamic>? ?? [];
    return results
        .map((json) => JournalModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<JournalModel> getJournalDetails(String journalId) async {
    final response = await _apiClient.get('/sources/$journalId');
    return JournalModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<String> getTopJournalName(String conceptId) async {
    try {
      final queryParams = <String, dynamic>{
        'filter': 'concepts.id:$conceptId',
        'group_by': 'primary_location.source.id',
      };
      final response = await _apiClient.get('/works', queryParameters: queryParams);
      final results = response['group_by'] as List<dynamic>? ?? [];
      
      for (final item in results) {
        final map = item as Map<String, dynamic>;
        final displayName = map['key_display_name'] as String? ?? '';
        final lowerName = displayName.toLowerCase();
        
        // Skip preprints and repository platforms to get actual journals/conferences
        if (lowerName.isEmpty ||
            lowerName.contains('arxiv') ||
            lowerName.contains('zenodo') ||
            lowerName.contains('ssrn') ||
            lowerName.contains('figshare') ||
            lowerName.contains('pubmed') ||
            lowerName.contains('biorxiv') ||
            lowerName.contains('medrxiv') ||
            lowerName.contains('research square') ||
            lowerName.contains('hal (') ||
            lowerName.contains('osf') ||
            lowerName.contains('preprints') ||
            lowerName.contains('eprints') ||
            lowerName.contains('repository')) {
          continue;
        }
        return displayName;
      }
    } catch (_) {}
    return 'N/A';
  }

  @override
  Future<PaperModel?> getMostInfluentialPaper(String conceptId) async {
    try {
      final queryParams = <String, dynamic>{
        'filter': 'concepts.id:$conceptId',
        'sort': 'cited_by_count:desc',
        'per_page': 1,
      };
      final response = await _apiClient.get('/works', queryParameters: queryParams);
      final results = response['results'] as List<dynamic>? ?? [];
      if (results.isNotEmpty) {
        return PaperModel.fromJson(results.first as Map<String, dynamic>);
      }
    } catch (_) {}
    return null;
  }
}
