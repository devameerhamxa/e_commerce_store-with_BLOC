import 'package:e_commerce_store_with_bloc/core/theme/theme_bloc/theme_event.dart';
import 'package:e_commerce_store_with_bloc/core/theme/theme_bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeInitial()) {
    on<ToggleTheme>(_onToggleTheme);
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    emit(ThemeChanged(event.isDarkMode ? ThemeMode.dark : ThemeMode.light));
  }
}
