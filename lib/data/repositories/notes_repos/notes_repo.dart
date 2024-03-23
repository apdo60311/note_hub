import 'package:note_hub/data/models/note/note.dart';

abstract class NotesRepository {
  Future<List<Note>> getNotes([int? limit]);
  Future getNote(String noteId);
  Future addNote(Note newNote);
  Future deleteNote(String noteId);
  Future updateNote(String noteId, Note newData);
  Future<List<Note>> getAllNotes();
  Future addNewNote(Note newNote);
  Future searchNotes(String text);
  Future getSavedNotes();
}
