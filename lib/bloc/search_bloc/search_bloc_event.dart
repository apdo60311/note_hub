part of 'search_bloc.dart';

sealed class SearchBlocEvent extends Equatable {
  const SearchBlocEvent();

  @override
  List<Object> get props => [];
}

class SearchBlocSearchEvent extends SearchBlocEvent {
  const SearchBlocSearchEvent({required this.text});
  final String text;

  @override
  List<Object> get props => [text];
}
