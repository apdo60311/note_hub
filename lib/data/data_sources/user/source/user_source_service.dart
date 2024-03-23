import 'dart:io';

import 'package:note_hub/data/models/user/user_model.dart';

abstract class UserSourceService {
  Future<void> setUserData(String userId, Map<String, dynamic> userData);

  Future<User> getUserData(String? userId);

  Future<void> updateUserData(Map<String, dynamic> data, String? userId);

  Future<String?> uploadFileToFirebaseStorage(File file, String path);

  Future deleteFileFromFirebaseStorage(String path);
}
