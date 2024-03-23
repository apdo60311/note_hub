import 'package:note_hub/data/models/user/user_model.dart';

abstract class UserAuthServiceInterface {
  Future<User> signIn(String email, String password);

  Stream<User> get user;

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signUp({required User user, required String password});

  Future<void> logOut();
}
