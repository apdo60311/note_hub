// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:note_hub/data/models/note/note.dart';
import 'package:note_hub/data/repositories/notes_repos/notes_repo.dart';

import '../../data_sources/remote/firebase_notes.dart';
import '../../data_sources/remote/remote_notes_source.dart';

class OnlineNotesRepository extends NotesRepository {
  final RemoteNotesSource remoteService = FirebaseNotesSource();

  @override
  Future addNote(Note newNote) {
    return remoteService.addNewNote(newNote);
  }

  @override
  Future deleteNote(String noteId) {
    return remoteService.deleteNote(noteId);
  }

  @override
  Future<List<Note>> getNotes([int? limit]) {
    return remoteService.getNotes(limit);
  }

  @override
  Future updateNote(String noteId, Note newData) {
    return remoteService.updateNote(noteId, newData);
  }

  @override
  Future getNote(String noteId) {
    return remoteService.getNote(noteId);
  }

  @override
  Future addNewNote(Note newNote) {
    return remoteService.addNewNote(newNote);
  }

  @override
  Future<List<Note>> getAllNotes() {
    return remoteService.getAllNotes();
  }

  @override
  Future getSavedNotes() {
    return remoteService.getSavedNotes();
  }

  @override
  Future searchNotes(String text) {
    return remoteService.searchNotes(text);
  }
}
