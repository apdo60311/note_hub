// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:note_hub/data/data_sources/user/auth/firebase/user_auth_firebase_service.dart';
import 'package:note_hub/data/data_sources/user/auth/user_auth_interface.dart';
import 'package:note_hub/data/data_sources/user/source/firebase_source_service.dart';
import 'package:note_hub/data/data_sources/user/source/user_source_service.dart';
import 'package:note_hub/data/models/user/user_model.dart';
import 'package:note_hub/data/repositories/user_repos/user_repo_interface.dart';

class FirebaseUserRepository implements UserRepository {
  @override
  UserAuthServiceInterface userAuthService;
  @override
  UserSourceService userSourceService;

  FirebaseUserRepository({
    UserAuthServiceInterface? userAuthService,
    UserSourceService? userSourceService,
  })  : userAuthService = userAuthService ?? FirebaseAuthService(),
        userSourceService = userSourceService ?? UserFirebaseSourceService();

  @override
  Future<User> getUserData(String? userId) async {
    return userSourceService.getUserData(userId);
  }

  @override
  Future<void> setUserData(String userId, Map<String, dynamic> userData) async {
    userSourceService.setUserData(userId, userData);
  }
}
