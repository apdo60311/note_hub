part of 'saved_notes_bloc.dart';

sealed class SavedNotesState extends Equatable {
  const SavedNotesState();

  @override
  List<Object> get props => [];
}

final class SavedNotesInitial extends SavedNotesState {}

final class SavedNotesSuccess extends SavedNotesState {
  final List<Note> savedNotes;

  const SavedNotesSuccess({required this.savedNotes});
}

final class SavedNotesFailure extends SavedNotesState {}
