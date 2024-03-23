part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {
  final User user;

  const AuthStarted({required this.user});
}

class AuthenticatedEvent extends AuthEvent {
  final User user;

  const AuthenticatedEvent({required this.user});
}

class UnAuthenticatedEvent extends AuthEvent {}


// class SignInAuthRequested extends AuthEvent {
//   final String username;
//   final String password;

//   const SignInAuthRequested({required this.username, required this.password});
// }

// class SignOutAuthRequested extends AuthEvent {}

// class RegisterAuthRequested extends AuthEvent {
//   final User userData;

//   const RegisterAuthRequested({required this.userData});
// }
