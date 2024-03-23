part of 'user_auth_firebase_service.dart';

extension on firebase_auth.User {
  User get toUser => User(
        id: uid,
        name: displayName ?? '',
        email: email ?? '',
        image: photoURL ?? defaultProfileImagePath,
        notesCount: 0,
        pinnedNotesCount: 0,
      );
}
