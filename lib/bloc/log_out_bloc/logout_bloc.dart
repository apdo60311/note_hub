import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_hub/data/repositories/user_repos/firebase_user_repository.dart';
import 'package:note_hub/data/repositories/user_repos/user_repo_interface.dart';
import 'package:note_hub/utils/cache_helper.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  late UserRepository userRepository = FirebaseUserRepository();

  LogoutBloc() : super(LogoutInitial()) {
    on<LogoutRequested>(_signUserOut);
  }

  void _signUserOut(event, emit) async {
    await userRepository.userAuthService.logOut().then((value) {
      SharedPreferencesHandler.clearData();
      return emit(const LogoutSuccesful());
    }).onError(
        (error, stackTrace) => emit(LogoutFaliure(message: error.toString())));
  }
}
