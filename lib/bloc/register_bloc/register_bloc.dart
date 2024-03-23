import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_hub/data/models/user/user_model.dart';
import 'package:note_hub/data/repositories/user_repos/firebase_user_repository.dart';
import 'package:note_hub/data/repositories/user_repos/user_repo_interface.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  late UserRepository userRepository = FirebaseUserRepository();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterRequested>(_registerUser);
  }

  void _registerUser(RegisterRequested event, emit) async {
    File? userProfileImageFile = event.imageFile;
    User userTobeRegistered = event.user;

    String? userProfileImageUrl;

    if (userProfileImageFile != null) {
      await userRepository.userSourceService
          .uploadFileToFirebaseStorage(
            userProfileImageFile,
            buildFirestorageFilePath(userTobeRegistered, userProfileImageFile),
          )
          .then((imageUrl) => userProfileImageUrl = imageUrl);
    }

    userTobeRegistered =
        userTobeRegistered.copyWith(image: userProfileImageUrl);

    await userRepository.userAuthService
        .signUp(user: userTobeRegistered, password: event.password)
        .then((user) => emit(RegisterSuccessful(user: userTobeRegistered)))
        .onError((error, stackTrace) async {
      if (userProfileImageFile != null) {
        await userRepository.userSourceService
            .deleteFileFromFirebaseStorage(buildFirestorageFilePath(
                userTobeRegistered, userProfileImageFile))
            .whenComplete(
                () => emit(RegisterFailure(message: error.toString())));
      }
    });
  }

  String buildFirestorageFilePath(
      User userTobeRegistered, File userProfileImageFile) {
    return '${userTobeRegistered.userProfile.name}/profileImage/${userProfileImageFile.path.split('/').last}';
  }
}
