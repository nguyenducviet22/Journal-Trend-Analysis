import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/prefs_keys.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(ThemeMode.dark) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeStr = _prefs.getString(PrefsKeys.themeMode);
    if (themeStr == 'light') {
      emit(ThemeMode.light);
    } else if (themeStr == 'system') {
      emit(ThemeMode.system);
    } else {
      emit(ThemeMode.dark);
    }
  }

  void setTheme(ThemeMode mode) async {
    emit(mode);
    await _prefs.setString(PrefsKeys.themeMode, mode.name);
  }
}
