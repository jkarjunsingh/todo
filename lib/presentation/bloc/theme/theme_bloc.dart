import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(LightTheme()) {
    on<ToggleTheme>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      bool isDark = state is LightTheme;
      isDark ? emit(DarkTheme()) : emit(LightTheme());
      await prefs.setBool("isDarkTheme", isDark);
    });
  }
}
