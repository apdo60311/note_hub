import 'package:equatable/equatable.dart';

class NoteSettings extends Equatable {
  late String? backgroundColor;
  final String? noteItemColor;
  final String? noteImageUrl;
  late String? noteBackgroundImageName;

  NoteSettings(
      {required this.backgroundColor,
      this.noteItemColor,
      this.noteImageUrl,
      this.noteBackgroundImageName});

  Map<String, dynamic> toMap() {
    return {
      'backgroundColor': backgroundColor,
      'noteItemColor': noteItemColor,
      'noteImageUrl': noteImageUrl,
      'noteBackgroundImageName': noteBackgroundImageName,
    };
  }

  factory NoteSettings.fromMap(Map<String, dynamic> map) {
    return NoteSettings(
      backgroundColor: map['backgroundColor'],
      noteItemColor: map['noteItemColor'],
      noteImageUrl: map['noteImageUrl'],
      noteBackgroundImageName: map['noteBackgroundImageName'],
    );
  }

  @override
  List<Object?> get props =>
      [backgroundColor, noteItemColor, noteImageUrl, noteBackgroundImageName];
}
