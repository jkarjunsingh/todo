import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

abstract class ThemeState {
  ThemeData get themeData;
}

class LightThemeState extends ThemeState {
  @override
  ThemeData get themeData => ThemeData.light();
}

class DarkThemeState extends ThemeState {
  @override
  ThemeData get themeData => ThemeData.dark();
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(LightThemeState()) {
    on<ToggleTheme>((event, emit) {
      state is LightThemeState
          ? emit(DarkThemeState())
          : emit(LightThemeState());
    });
  }
}