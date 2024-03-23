part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [DateTime.now()];
}

final class NotesFetched extends NotesEvent {
  @override
  List<Object> get props => [DateTime.now()];
}

// ignore: must_be_immutable
final class NotesReFetched extends NotesEvent {
  Note? note;

  NotesReFetched({this.note});

  @override
  List<Object> get props => [note ?? ""];
}
