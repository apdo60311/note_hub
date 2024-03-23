part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginSuccesful extends LoginState {
  final User user;

  const LoginSuccesful({required this.user});

  @override
  List<Object> get props => [user];
}

final class LoginFaliure extends LoginState {
  final String message;

  const LoginFaliure({required this.message});

  @override
  List<Object> get props => [message];
}
