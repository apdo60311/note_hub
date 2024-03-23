import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:note_hub/config/constants/shared_preference_keys.dart';
import 'package:note_hub/config/themes/app_themes.dart';
import 'package:note_hub/utils/cache_helper.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial(ThemeData.light())) {
    on<ThemeInitialEvent>(_onThemeInitial);
    on<ThemeChangeEvent>(_onThemeChanged);
  }

  FutureOr<void> _onThemeChanged(event, emit) {
    if (event.themeState == ThemeType.light) {
      SharedPreferencesHandler.setBooleanData(
          key: SharedPreferencesConstants.isDarkTheme, value: false);
      emit(ThemeChanged(lightThemeData));
    } else {
      SharedPreferencesHandler.setBooleanData(
          key: SharedPreferencesConstants.isDarkTheme, value: true);

      emit(ThemeChanged(darkThemeData));
    }
  }

  FutureOr<void> _onThemeInitial(
      ThemeInitialEvent event, Emitter<ThemeState> emit) {
    bool? isDark = SharedPreferencesHandler.getBooleanData(
            key: SharedPreferencesConstants.isDarkTheme) ??
        false;

    if (!isDark) {
      emit(ThemeChanged(lightThemeData));
    } else {
      emit(ThemeChanged(darkThemeData));
    }
  }
}
