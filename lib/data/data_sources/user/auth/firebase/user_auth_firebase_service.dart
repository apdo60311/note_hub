import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:note_hub/config/constants/assets_constants.dart';
import 'package:note_hub/config/constants/shared_preference_keys.dart';
import 'package:note_hub/data/data_sources/user/auth/user_auth_interface.dart';
import 'package:note_hub/data/data_sources/user/source/firebase_source_service.dart';
import 'package:note_hub/data/models/user/user_model.dart';
import 'package:note_hub/utils/cache_helper.dart';

part 'firebase_exceptions.dart';
part 'firebase_touser_extension.dart';

class FirebaseAuthService implements UserAuthServiceInterface {
  FirebaseAuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    UserFirebaseSourceService? userFirebaseSourceService,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _userFirebaseSourceService =
            userFirebaseSourceService ?? UserFirebaseSourceService();

  final firebase_auth.FirebaseAuth _firebaseAuth;

  final UserFirebaseSourceService _userFirebaseSourceService;

  bool checkUserLoggingState() =>
      SharedPreferencesHandler.getBooleanData(
          key: SharedPreferencesConstants.isLoggedIn) !=
      null;

  @override
  Future<User> signIn(String email, String password) async {
    return logInWithEmailAndPassword(email: email, password: password)
        .then((value) => _userFirebaseSourceService
            .getUserData(_firebaseAuth.currentUser?.uid))
        .catchError((error, stackTrace) {
      throw error;
    });
  }

  @override
  Stream<User> get user {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      return (firebaseUser == null) ? User.empty : firebaseUser.toUser;
    });
  }

  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> signUp({required User user, required String password}) async {
    try {
      // firebase_auth.UserCredential newUser =
      await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: user.userProfile.email,
        password: password,
      )
          .then((newUser) async {
        user = user.copyWith(id: newUser.user!.uid);
        await _userFirebaseSourceService.setUserData(user.id, user.toMap());
        return newUser;
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}
