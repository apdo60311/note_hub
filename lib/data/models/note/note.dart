import 'package:equatable/equatable.dart';
import 'package:note_hub/data/models/note/modifications/note_settings.dart';

abstract class Note extends Equatable {
  late final String id;
  late final String userId;
  late String title;
  late List content;
  late String creationTime;
  late NoteSettings noteSettings;
  abstract bool isPinned;

  Map<String, dynamic> toMap();

  @override
  List<Object?> get props =>
      [id, userId, title, content, creationTime, noteSettings, isPinned];
}
