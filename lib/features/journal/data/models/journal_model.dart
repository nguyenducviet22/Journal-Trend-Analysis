import '../../domain/entities/journal.dart';

class JournalModel extends Journal {
  const JournalModel({
    required super.id,
    required super.displayName,
    required super.worksCount,
    required super.citedByCount,
    super.homepageUrl,
    super.publisher,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    final fullId = json['id'] as String? ?? '';
    final cleanedId = fullId.split('/').last;

    return JournalModel(
      id: cleanedId,
      displayName: json['display_name'] as String? ?? 'Unknown Journal',
      worksCount: json['works_count'] as int? ?? 0,
      citedByCount: json['cited_by_count'] as int? ?? 0,
      homepageUrl: json['homepage_url'] as String?,
      publisher: json['publisher'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'works_count': worksCount,
      'cited_by_count': citedByCount,
      'homepage_url': homepageUrl,
      'publisher': publisher,
    };
  }

  factory JournalModel.fromDbMap(Map<dynamic, dynamic> map) {
    return JournalModel(
      id: map['id'] as String? ?? '',
      displayName: map['display_name'] as String? ?? '',
      worksCount: map['works_count'] as int? ?? 0,
      citedByCount: map['cited_by_count'] as int? ?? 0,
      homepageUrl: map['homepage_url'] as String?,
      publisher: map['publisher'] as String?,
    );
  }
}
