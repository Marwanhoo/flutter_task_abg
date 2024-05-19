import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  ThemeMode themeMode = ThemeMode.dark;

  void changeAppMode() {
    themeMode =
    (themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    emit(AppChangeModeState(themeMode));
  }
}
