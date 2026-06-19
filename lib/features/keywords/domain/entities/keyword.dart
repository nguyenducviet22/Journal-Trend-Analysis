import 'package:equatable/equatable.dart';

class Keyword extends Equatable {
  final String id;
  final String displayName;
  final int level;
  final int worksCount;

  const Keyword({
    required this.id,
    required this.displayName,
    required this.level,
    required this.worksCount,
  });

  @override
  List<Object?> get props => [id, displayName, level, worksCount];
}
