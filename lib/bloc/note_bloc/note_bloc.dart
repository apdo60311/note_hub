import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_hub/data/models/note/note.dart';
import 'package:note_hub/data/repositories/notes_repos/notes_repo.dart';
import 'package:note_hub/utils/pdf_handler.dart';

import '../note_modification_state.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NotesRepository notesRepository;
  NoteBloc(this.notesRepository) : super(const NoteInitial()) {
    on<NoteInit>((event, emit) => emit(const NoteInitial()));
    on<NoteInserted>(_onNoteInserted);
    on<NoteUpdated>(_onNoteUpdated);
    on<NoteDeleted>(_onNoteDeleted);
    on<NoteSavedAsPdf>(_onNoteSavedAsPdf);
  }

  FutureOr<void> _onNoteUpdated(
      NoteUpdated event, Emitter<NoteState> emit) async {
    try {
      if (!event.isEmpty) {
        await _updateNote(event.noteId, event.note);
        emit(NoteSaved("Note Updated Successfully", event.note,
            ModificationState.updated));
      } else {
        emit(const NoteDiscarded("Empty Note Discarded"));
      }
    } on Exception catch (e) {
      emit(NoteFailure(e.toString()));
    }
  }

  FutureOr<void> _onNoteInserted(
      NoteInserted event, Emitter<NoteState> emit) async {
    try {
      if (!event.isEmpty) {
        await _insertNote(event.note)
            .onError((error, stackTrace) => debugPrint('ERRROR $error'));
        emit(NoteSaved(
            "Note Saved Successfully", event.note, ModificationState.inserted));
      } else {
        emit(const NoteDiscarded("Empty Note Discarded"));
      }
    } on Exception catch (e) {
      emit(NoteFailure(e.toString()));
    }
  }

  Future _insertNote(Note newNote) async {
    return notesRepository.addNewNote(newNote);
  }

  Future _updateNote(String noteId, Note note) {
    return notesRepository.updateNote(noteId, note);
  }

  FutureOr<void> _onNoteDeleted(
      NoteDeleted event, Emitter<NoteState> emit) async {
    try {
      await notesRepository.deleteNote(event.noteId);
      emit(NoteDeletedState("Note deleted Successfully", event.noteId));
    } on Expanded catch (e) {
      emit(NoteFailure(e.toString()));
    }
  }

  FutureOr<void> _onNoteSavedAsPdf(
      NoteSavedAsPdf event, Emitter<NoteState> emit) async {
    await PdfHandler.instance.generate(note: event.note).then((file) {
      emit(NoteSavedAsPdfSuccess(path: file.path));
    }).onError((error, stackTrace) {
      emit(const NoteFailure('Cannot save this note!'));
    });
  }
}
