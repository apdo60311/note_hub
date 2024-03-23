// ignore_for_file: must_be_immutable

part of 'note_bloc.dart';

sealed class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

final class NoteSavedAsPdf extends NoteEvent {
  final Note note;

  const NoteSavedAsPdf(this.note);

  @override
  List<Object> get props => [note];
}

final class NoteDeleted extends NoteEvent {
  final String noteId;

  const NoteDeleted(this.noteId);

  @override
  List<Object> get props => [noteId];
}

final class NoteInserted extends NoteEvent {
  final Note note;
  final bool isEmpty;

  const NoteInserted(this.note, this.isEmpty);

  @override
  List<Object> get props => [note, isEmpty];
}

final class NoteUpdated extends NoteEvent {
  final Note note;
  final bool isEmpty;
  final String noteId;

  const NoteUpdated(this.noteId, this.note, this.isEmpty);

  @override
  List<Object> get props => [note, isEmpty, noteId];
}

final class NoteInit extends NoteEvent {
  Note? note;

  NoteInit({note}) : super();

  @override
  List<Object> get props => [note ?? ""];
}
