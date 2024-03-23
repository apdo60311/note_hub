part of 'theme_bloc.dart';

enum ThemeType { dark, light }

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeInitialEvent extends ThemeEvent {}

class ThemeChangeEvent extends ThemeEvent {
  const ThemeChangeEvent({required this.themeState});
  final ThemeType themeState;
  @override
  List<Object> get props => [themeState];
}
