import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_hub/data/models/note/note.dart';
import 'package:note_hub/data/repositories/notes_repos/notes_repo.dart';

part 'search_bloc_event.dart';
part 'search_bloc_state.dart';

class SearchBloc extends Bloc<SearchBlocEvent, SearchBlocState> {
  final NotesRepository notesRepository;
  SearchBloc(this.notesRepository) : super(SearchBlocInitial()) {
    on<SearchBlocSearchEvent>((event, emit) async {
      emit(SearchBlocLoading());
      List<Note> notes = await notesRepository.searchNotes(event.text);
      emit(SearchBlocResultState(resultList: notes));
    });
  }
}
