part of 'theme_bloc.dart';

sealed class ThemeState extends Equatable {
  const ThemeState(this.themeData);
  final ThemeData themeData;

  @override
  List<Object> get props => [themeData];
}

final class ThemeInitial extends ThemeState {
  const ThemeInitial(super.themeData);
  @override
  List<Object> get props => [themeData];
}

final class ThemeChanged extends ThemeState {
  const ThemeChanged(super.themeData);
  @override
  List<Object> get props => [themeData];
}
