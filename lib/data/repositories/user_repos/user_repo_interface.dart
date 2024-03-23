// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:note_hub/data/data_sources/user/auth/user_auth_interface.dart';
import 'package:note_hub/data/data_sources/user/source/user_source_service.dart';
import 'package:note_hub/data/models/user/user_model.dart';

abstract class UserRepository {
  UserAuthServiceInterface userAuthService;
  UserSourceService userSourceService;

  UserRepository({
    required this.userAuthService,
    required this.userSourceService,
  });

  // user control
  Future<void> setUserData(String userId, Map<String, dynamic> userData);

  Future<User> getUserData(String? userId);
}
