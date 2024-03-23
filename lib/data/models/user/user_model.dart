// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserProfile {
  late String name;
  late String email;
  late String image;
  late int notesCount;
  late int pinnedNotesCount;

  UserProfile({
    required this.name,
    required this.email,
    required this.image,
    this.notesCount = 0,
    this.pinnedNotesCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'image': image,
      'notesCount': notesCount,
      'pinnedNotesCount': pinnedNotesCount,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] as String,
      email: map['email'] as String,
      image: map['image'] as String,
      notesCount: map['notesCount'] as int,
      pinnedNotesCount: map['pinnedNotesCount'] as int,
    );
  }
}

class User {
  late final String id;
  late UserProfile userProfile;

  User({
    required this.id,
    required String name,
    required String email,
    required String image,
    required int notesCount,
    required int pinnedNotesCount,
  }) : userProfile = UserProfile(
            name: name,
            email: email,
            image: image,
            notesCount: notesCount,
            pinnedNotesCount: pinnedNotesCount);

  static final User empty = User(
      id: '0',
      name: '',
      email: '',
      image: '',
      notesCount: 0,
      pinnedNotesCount: 0);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profile': userProfile.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['profile']['name'] as String,
      email: map['profile']['email'] as String,
      image: map['profile']['image'] as String,
      notesCount: map['profile']['notesCount'],
      pinnedNotesCount: map['profile']['pinnedNotesCount'],
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? image,
    int? notesCount,
    int? pinnedNotesCount,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? userProfile.name,
        email: email ?? userProfile.email,
        image: image ?? userProfile.image,
        notesCount: notesCount ?? userProfile.notesCount,
        pinnedNotesCount: pinnedNotesCount ?? userProfile.pinnedNotesCount,
      );
}
