import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:note_hub/bloc/notes_bloc/notes_bloc.dart';
import 'package:note_hub/presentation/widgets/note_widget.dart';
import 'package:note_hub/utils/note_shimmer_effect.dart';
import 'package:note_hub/utils/shared_methods.dart';

import '../../bloc/note_bloc/note_bloc.dart';

class NotesGrid extends StatefulWidget {
  const NotesGrid({Key? key}) : super(key: key);

  @override
  State<NotesGrid> createState() => _NotesGridState();
}

class _NotesGridState extends State<NotesGrid> with TickerProviderStateMixin {
  late ScrollController _scrollController;

  late AnimationController _notesAnimationController;

  bool _isLoading = false;

  int _selectedNote = -1;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _notesAnimationHandler();
    super.initState();
  }

  void _notesAnimationHandler() {
    _notesAnimationController = AnimationController(vsync: this);
    _notesAnimationController.duration = const Duration(milliseconds: 500);

    _notesAnimationController.addListener(() {
      setState(() {});
    });
  }

  void _onScroll() {
    if (_isBottom && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      context.read<NotesBloc>().add(NotesFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _notesAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is NoteDeletedState) {
          context.read<NotesBloc>().add(NotesFetched());
        }
      },
      child: BlocConsumer<NotesBloc, NotesState>(
        listener: (BuildContext context, NotesState state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case NotesInitialState:
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
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return const NoteShimmerEffect();
                  },
                ),
              );
            case NotesFailureState:
              return const Center(
                child: Text('Error'),
              );
            case NotesSuccessState:
              if ((state as NotesSuccessState).notes.isEmpty) {
                return emptyAnimation();
              }
              _notesAnimationController.forward();
              _isLoading = false;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<NotesBloc>().add(NotesFetched());
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 195,
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                    ),
                    itemCount: state.notes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimatedScale(
                        scale: _notesAnimationController.value,
                        duration: Duration(milliseconds: 50 * (index + 1) * 5),
                        child: GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _selectedNote = index;
                            });
                          },
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
                                      note: state.notes[index],
                                      index: index,
                                      isSelected: index == _selectedNote,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.read<NoteBloc>().add(
                                          NoteDeleted(state.notes[index].id));
                                      _selectedNote = -1;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.grey.shade300,
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
                                        arguments: state.notes[index])
                                    .then((isChangeOccurred) {
                                  if (isChangeOccurred != null &&
                                      isChangeOccurred as bool) {
                                    if (context.mounted) {
                                      context
                                          .read<NotesBloc>()
                                          .add(NotesFetched());
                                    }
                                  }
                                });
                              },
                              child: NoteWidget(
                                note: state.notes[index],
                                index: index,
                                isSelected: index == _selectedNote,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            default:
              return const Center(
                child: Text('Error state'),
              );
          }
        },
      ),
    );
  }
}
