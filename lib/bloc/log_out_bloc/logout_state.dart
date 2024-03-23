part of 'logout_bloc.dart';

sealed class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

final class LogoutInitial extends LogoutState {}

final class LogoutSuccesful extends LogoutState {
  const LogoutSuccesful();
}

final class LogoutFaliure extends LogoutState {
  final String message;

  const LogoutFaliure({required this.message});
}
