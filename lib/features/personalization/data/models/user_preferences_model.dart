import '../../domain/entities/user_preferences.dart';

class UserPreferencesModel extends UserPreferences {
  const UserPreferencesModel({
    required super.fullName,
    required super.interestConceptId,
    required super.interestConceptName,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      fullName: json['fullName'] as String? ?? '',
      interestConceptId: json['interestConceptId'] as String? ?? '',
      interestConceptName: json['interestConceptName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'interestConceptId': interestConceptId,
      'interestConceptName': interestConceptName,
    };
  }

  factory UserPreferencesModel.fromEntity(UserPreferences entity) {
    return UserPreferencesModel(
      fullName: entity.fullName,
      interestConceptId: entity.interestConceptId,
      interestConceptName: entity.interestConceptName,
    );
  }
}
