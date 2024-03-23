import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_hub/data/models/user/user_model.dart';
import 'package:note_hub/data/repositories/user_repos/firebase_user_repository.dart';
import 'package:note_hub/data/repositories/user_repos/user_repo_interface.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository = FirebaseUserRepository();

  late final StreamSubscription<User?> _userSupscription;

  AuthBloc() : super(UserAuthenticationState.unKnown()) {
    _userSupscription = userRepository.userAuthService.user.listen((user) {
      add(AuthStarted(user: user));
    });

    on<AuthStarted>(_startAuth);
    on<AuthenticatedEvent>(_onAuthenticated);
    on<UnAuthenticatedEvent>(_onUnAuthenticated);
  }

  FutureOr<void> _onAuthenticated(AuthenticatedEvent event, emit) async {
    await userRepository.getUserData(event.user.id).then((user) {
      emit(UserAuthenticationState.authenticated(user: user));
    });
  }

  FutureOr<void> _onUnAuthenticated(UnAuthenticatedEvent event, emit) =>
      emit(UserAuthenticationState.unauthenticated());

  void _startAuth(AuthStarted event, Emitter<AuthState> emit) async {
    if (event.user != User.empty) {
      add(AuthenticatedEvent(user: event.user));
    } else {
      add(UnAuthenticatedEvent());
    }
  }

  @override
  Future<void> close() {
    _userSupscription.cancel();
    return super.close();
  }
}
