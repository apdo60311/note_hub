part of 'auth_bloc.dart';

enum UserAuthState { unknown, authenticated, unauthenticated }

sealed class AuthState extends Equatable {
  abstract final User? user;
  abstract final UserAuthState? state;
  @override
  List<Object> get props =>
      [user ?? User.empty, state ?? UserAuthState.unknown];
}

final class UserAuthenticationState extends AuthState {
  @override
  final User? user;
  @override
  final UserAuthState? state;
  UserAuthenticationState._({this.user, this.state = UserAuthState.unknown});

  UserAuthenticationState.unKnown() : this._();
  UserAuthenticationState.authenticated({User? user})
      : this._(user: user, state: UserAuthState.authenticated);
  UserAuthenticationState.unauthenticated()
      : this._(state: UserAuthState.unauthenticated);
}

// final class UserAuthenticated extends AuthState {
//   final UserProfile userProfile;
//   final int notesCount;
//   UserAuthenticated({required this.userProfile, required this.notesCount});
// }

// final class UserUnAuthenticated extends AuthState {}

// final class UserDataUpdated extends AuthState {
//   final UserProfile userProfile;
//   final int notesCount;

//   UserDataUpdated({required this.userProfile, required this.notesCount});
// }

// final class UserAuthSuccess extends AuthState {}

// final class UserAuthError extends AuthState {
//   final String message;

//   UserAuthError({required this.message});
// }
