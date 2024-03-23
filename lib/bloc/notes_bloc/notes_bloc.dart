import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_hub/data/models/note/note.dart';
import 'package:note_hub/data/repositories/notes_repos/notes_repo.dart';

part 'notes_event.dart';
part 'notes_state.dart';

const _noteCountToLoad = 6;

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository notesRepository;

  NotesBloc(this.notesRepository) : super(NotesInitialState()) {
    on<NotesFetched>(_onNoteFetched);
    // on<NotesReFetched>(_onNotesReFetched);
  }

  Future<void> _onNoteFetched(NotesEvent event, emit) async {
    try {
      if (state is NotesInitialState) {
        final List<Note> notes = await _fetchNotes(7);
        return emit(NotesSuccessState(notes: notes, hasReachedMax: false));
      } else {
        List<Note> stateNotes = (state as NotesSuccessState).notes;

        final List<Note> notes =
            await _fetchNotes((stateNotes.length + _noteCountToLoad));
        if (notes.isEmpty) {
          return emit(NotesSuccessState(notes: notes, hasReachedMax: true));
        } else {
          return emit(NotesSuccessState(notes: notes, hasReachedMax: false));
        }
      }
    } catch (e) {
      return emit(NotesFailureState(e.toString()));
    }
  }

  Future<List<Note>> _fetchNotes([int? limit]) async {
    return notesRepository.getNotes(limit);
  }
}
