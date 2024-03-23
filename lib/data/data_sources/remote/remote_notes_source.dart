import 'package:note_hub/data/models/note/note.dart';

/// class to deal with remote data
/// Firebase
abstract class RemoteNotesSource {
  Future<List<Note>> getAllNotes();

  Future<List<Note>> getNotes([int? limit]);

  Future getNote(String noteId);

  Future addNewNote(Note newNote);

  Future deleteNote(String noteId);

  Future updateNote(String noteId, Note newData);

  Future searchNotes(String text);

  Future getSavedNotes();
}
