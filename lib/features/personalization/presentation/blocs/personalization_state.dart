import 'package:equatable/equatable.dart';
import '../../domain/entities/user_preferences.dart';

abstract class PersonalizationState extends Equatable {
  const PersonalizationState();

  @override
  List<Object?> get props => [];
}

class PersonalizationInitial extends PersonalizationState {}

class PersonalizationLoading extends PersonalizationState {}

class PersonalizationLoaded extends PersonalizationState {
  final UserPreferences? preferences;
  final String? generatedName;

  const PersonalizationLoaded({this.preferences, this.generatedName});

  @override
  List<Object?> get props => [preferences, generatedName];
}

class PersonalizationSuccess extends PersonalizationState {}

class PersonalizationFailure extends PersonalizationState {
  final String message;

  const PersonalizationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
