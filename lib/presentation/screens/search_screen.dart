import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:note_hub/bloc/search_bloc/search_bloc.dart';

import '../../bloc/note_bloc/note_bloc.dart';
import '../../bloc/notes_bloc/notes_bloc.dart';
import '../widgets/note_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  int _selectedNote = -1;

  // List<Note> _listNotes = [];

  @override
  void initState() {
    // _listNotes = widget.notes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          hintText: 'Search your notes...',
          hintStyle:
              const MaterialStatePropertyAll(TextStyle(color: Colors.grey)),
          elevation: const MaterialStatePropertyAll(0),
          onChanged: (value) {
            context.read<SearchBloc>().add(SearchBlocSearchEvent(text: value));
          },
        ),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: BlocBuilder<SearchBloc, SearchBlocState>(
        builder: (context, state) {
          if (state is SearchBlocResultState) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 195,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: state.resultList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onLongPress: () {},
                    child: ConditionalBuilder(
                      condition: index == _selectedNote,
                      builder: (BuildContext context) => InkWell(
                        onTap: () {
                          setState(() {
                            _selectedNote = -1;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Positioned.fill(
                              child: NoteWidget(
                                note: state.resultList[index],
                                index: index,
                                isSelected: index == _selectedNote,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context.read<NoteBloc>().add(
                                    NoteDeleted(state.resultList[index].id));
                                _selectedNote = -1;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  radius: 16,
                                  child: Lottie.asset(
                                      "assets/animations/delete_animation.json",
                                      repeat: false,
                                      width: 22),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      fallback: (BuildContext context) => InkWell(
                        onTap: () async {
                          await Navigator.pushNamed(context, '/open_note',
                                  arguments: state.resultList[index])
                              .then((isChangeOccurred) {
                            if (isChangeOccurred != null &&
                                isChangeOccurred as bool) {
                              if (context.mounted) {
                                context.read<NotesBloc>().add(NotesFetched());
                              }
                            }
                          });
                        },
                        child: NoteWidget(
                          note: state.resultList[index],
                          index: index,
                          isSelected: index == _selectedNote,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
