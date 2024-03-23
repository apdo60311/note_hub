part of 'search_bloc.dart';

sealed class SearchBlocState extends Equatable {
  const SearchBlocState();

  @override
  List<Object> get props => [];
}

final class SearchBlocInitial extends SearchBlocState {}

final class SearchBlocLoading extends SearchBlocState {}

final class SearchBlocResultState extends SearchBlocState {
  final List<Note> resultList;
  const SearchBlocResultState({required this.resultList});
}
