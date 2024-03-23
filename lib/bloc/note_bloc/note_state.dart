part of 'note_bloc.dart';

sealed class NoteState extends Equatable {
  final String message;

  const NoteState(this.message);

  @override
  List<Object> get props => [];
}

final class NoteInitial extends NoteState {
  const NoteInitial() : super("Initial state");
}

final class NoteSaved extends NoteState {
  final Note savedNote;
  final ModificationState modificationState;

  const NoteSaved(super.message, this.savedNote, this.modificationState);

  @override
  List<Object> get props => [savedNote, modificationState, DateTime.now()];
}

final class NoteDiscarded extends NoteState {
  const NoteDiscarded(super.message);
}

final class NoteFailure extends NoteState {
  const NoteFailure(super.message);

  @override
  List<Object> get props => [DateTime.now()];
}

final class NoteDeletedState extends NoteState {
  final String deletedNoteId;

  const NoteDeletedState(super.message, this.deletedNoteId);

  @override
  List<Object> get props => [message, deletedNoteId];
}

final class NoteSavedAsPdfSuccess extends NoteState {
  final String path;

  const NoteSavedAsPdfSuccess({required this.path})
      : super("Saved Successfully");

  @override
  List<Object> get props => [path, DateTime.now()];
}
