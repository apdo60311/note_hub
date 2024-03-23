import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_hub/config/constants/shared_preference_keys.dart';
import 'package:note_hub/data/models/user/user_model.dart';
import 'package:note_hub/data/repositories/user_repos/firebase_user_repository.dart';
import 'package:note_hub/data/repositories/user_repos/user_repo_interface.dart';
import 'package:note_hub/utils/cache_helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late UserRepository userRepository = FirebaseUserRepository();

  LoginBloc() : super(LoginInitial()) {
    on<LoginRequested>(_login);
  }

  Future<void> _login(LoginRequested event, Emitter<LoginState> emit) async {
    await userRepository.userAuthService
        .signIn(event.username, event.password)
        .then((user) {
      SharedPreferencesHandler.setBooleanData(
          key: SharedPreferencesConstants.isLoggedIn, value: true);
      SharedPreferencesHandler.setStringData(
          key: SharedPreferencesConstants.usernameKey,
          value: user.userProfile.name);
      SharedPreferencesHandler.setStringData(
          key: SharedPreferencesConstants.emailKey,
          value: user.userProfile.email);
      SharedPreferencesHandler.setStringData(
          key: SharedPreferencesConstants.imageKey,
          value: user.userProfile.image);
      SharedPreferencesHandler.setIntData(
          key: SharedPreferencesConstants.notesCountKey,
          value: user.userProfile.notesCount);
      emit(LoginSuccesful(
        user: user,
      ));
    }).catchError((error, stackTrace) {
      emit(LoginFaliure(message: error.message.toString()));
    });
  }
}
