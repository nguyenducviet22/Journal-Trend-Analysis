import '../../domain/entities/keyword.dart';

class KeywordModel extends Keyword {
  const KeywordModel({
    required super.id,
    required super.displayName,
    required super.level,
    required super.worksCount,
  });

  factory KeywordModel.fromJson(Map<String, dynamic> json) {
    final fullId = json['id'] as String? ?? '';
    final cleanedId = fullId.split('/').last;

    return KeywordModel(
      id: cleanedId,
      displayName: json['display_name'] as String? ?? 'Unknown Keyword',
      level: json['level'] as int? ?? 0,
      worksCount: json['works_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'level': level,
      'works_count': worksCount,
    };
  }

  factory KeywordModel.fromDbMap(Map<dynamic, dynamic> map) {
    return KeywordModel(
      id: map['id'] as String? ?? '',
      displayName: map['display_name'] as String? ?? '',
      level: map['level'] as int? ?? 0,
      worksCount: map['works_count'] as int? ?? 0,
    );
  }
}
