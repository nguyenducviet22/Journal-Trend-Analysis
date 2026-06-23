import '../../domain/entities/user_preferences.dart';

class UserPreferencesModel extends UserPreferences {
  const UserPreferencesModel({
    required super.fullName,
    required super.email,
    required super.photoUrl,
    required super.interestConceptId,
    required super.interestConceptName,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String? ?? '',
      interestConceptId: json['interestConceptId'] as String? ?? '',
      interestConceptName: json['interestConceptName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
      'interestConceptId': interestConceptId,
      'interestConceptName': interestConceptName,
    };
  }

  factory UserPreferencesModel.fromEntity(UserPreferences entity) {
    return UserPreferencesModel(
      fullName: entity.fullName,
      email: entity.email,
      photoUrl: entity.photoUrl,
      interestConceptId: entity.interestConceptId,
      interestConceptName: entity.interestConceptName,
    );
  }
}
