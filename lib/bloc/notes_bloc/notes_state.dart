part of 'notes_bloc.dart';

final class NotesState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class NotesInitialState extends NotesState {}

final class NotesSuccessState extends NotesState {
  final List<Note> notes;
  final bool hasReachedMax;

  NotesSuccessState({required this.notes, required this.hasReachedMax});

  @override
  List<Object> get props => [notes, hasReachedMax, notes.length];
}

final class NotesFailureState extends NotesState {
  final String message;

  NotesFailureState(this.message);
}
