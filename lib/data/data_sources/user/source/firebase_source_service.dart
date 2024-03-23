import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:note_hub/data/data_sources/user/source/user_source_service.dart';
import 'package:note_hub/data/models/user/user_model.dart';

class UserFirebaseSourceService implements UserSourceService {
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  final _firebaseStorageRef = FirebaseStorage.instance.ref();

  @override
  Future<void> setUserData(String userId, Map<String, dynamic> userData) async {
    try {
      await _usersCollection.doc(userId).set(userData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> getUserData(String? userId) async {
    return _usersCollection.doc(userId).get().then((value) {
      if (value.exists && value.data() != null) {
        return User.fromMap(value.data()!);
      } else {
        return User.empty;
      }
    }).onError((error, stackTrace) {
      return User.empty;
    });
  }

  @override
  Future<String?> uploadFileToFirebaseStorage(File file, String path) async {
    file.path;
    return _firebaseStorageRef.child(path).putFile(file).then((p0) {
      return p0.ref.getDownloadURL();
    });
  }

  @override
  Future deleteFileFromFirebaseStorage(String path) {
    final desertRef = _firebaseStorageRef.child(path);
    return desertRef.delete();
  }

  @override
  Future<void> updateUserData(data, String? userId) {
    return _usersCollection.doc(userId).set(data, SetOptions(merge: true));
  }
}
