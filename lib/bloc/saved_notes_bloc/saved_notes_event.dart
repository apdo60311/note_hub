part of 'saved_notes_bloc.dart';

sealed class SavedNotesEvent extends Equatable {
  const SavedNotesEvent();

  @override
  List<Object> get props => [];
}

class SavedNotesFetched extends SavedNotesEvent {}
