import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_hub/data/models/note/note.dart';
import 'package:note_hub/data/repositories/notes_repos/notes_repo.dart';

part 'saved_notes_event.dart';
part 'saved_notes_state.dart';

class SavedNotesBloc extends Bloc<SavedNotesEvent, SavedNotesState> {
  final NotesRepository notesRepository;
  SavedNotesBloc(this.notesRepository) : super(SavedNotesInitial()) {
    on<SavedNotesFetched>(_onSavedNotesFetched);
  }

  FutureOr<void> _onSavedNotesFetched(event, emit) async {
    try {
      List<Note> savedNotes = await notesRepository.getSavedNotes();
      emit(SavedNotesSuccess(savedNotes: savedNotes));
    } catch (e) {
      emit(SavedNotesFailure());
    }
  }
}
