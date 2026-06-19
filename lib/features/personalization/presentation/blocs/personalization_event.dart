import 'package:equatable/equatable.dart';
import '../../domain/entities/user_preferences.dart';

abstract class PersonalizationEvent extends Equatable {
  const PersonalizationEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserPreferences extends PersonalizationEvent {}

class GenerateRandomNameEvent extends PersonalizationEvent {}

class SavePreferencesEvent extends PersonalizationEvent {
  final UserPreferences preferences;

  const SavePreferencesEvent(this.preferences);

  @override
  List<Object?> get props => [preferences];
}
