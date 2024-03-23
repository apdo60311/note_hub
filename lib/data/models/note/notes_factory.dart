import 'package:note_hub/data/models/note/modifications/note_settings.dart';
import 'package:note_hub/data/models/note/note.dart';
import 'package:note_hub/data/models/note/textual_note.dart';
import 'package:note_hub/utils/shared_colors.dart';
import 'package:note_hub/utils/shared_methods.dart';

class NotesFactory {
  NotesFactory._();

  static Note createDefaultNote() => TextualNote(
      id: getNextNoteId(),
      title: '',
      creationTime: getCurrentTime(),
      content: [],
      noteSettings: NoteSettings(
        backgroundColor: defaultNoteBackgroundColor,
      ),
      isPinned: false,
      userId: 'empty');

  static String getNextNoteId() => "00";
}
