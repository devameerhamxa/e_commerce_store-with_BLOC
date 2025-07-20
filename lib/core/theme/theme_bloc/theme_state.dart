import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}

class ThemeInitial extends ThemeState {
  // Default to system theme on app start
  const ThemeInitial() : super(ThemeMode.system);
}

class ThemeChanged extends ThemeState {
  const ThemeChanged(ThemeMode themeMode) : super(themeMode);
}
