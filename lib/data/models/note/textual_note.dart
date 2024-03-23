import 'package:note_hub/data/models/note/modifications/note_settings.dart';
import 'package:note_hub/data/models/note/note_content_section.dart';

import 'note.dart';

class TextualNote implements Note {
  @override
  String id;
  @override
  String userId;
  @override
  late String title;
  @override
  late String creationTime;
  @override
  late List content;
  @override
  late NoteSettings noteSettings;
  @override
  late bool isPinned;

  TextualNote({
    required this.id,
    required this.userId,
    required this.title,
    required this.creationTime,
    required this.content,
    required this.noteSettings,
    required this.isPinned,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'creationTime': creationTime,
      'content': content.map((e) => e.toMap()).toList(),
      'settings': noteSettings.toMap(),
      'isPinned': isPinned,
    };
  }

  factory TextualNote.fromMap(Map<String, dynamic> map) {
    Iterable<NoteContentSection> contentFromMap = (map['content']! as List)
        .map((section) => NoteContentSection.fromMap(section))
        .toList();

    return TextualNote(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      creationTime: map['creationTime'] as String,
      content: contentFromMap as List,
      noteSettings: NoteSettings.fromMap(map['settings']),
      isPinned: map['isPinned'],
    );
  }

  @override
  List<Object?> get props =>
      [title, creationTime, isPinned, content, noteSettings];

  @override
  bool? get stringify => true;
}
