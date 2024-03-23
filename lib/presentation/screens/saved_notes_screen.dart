import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_hub/bloc/saved_notes_bloc/saved_notes_bloc.dart';
import 'package:note_hub/presentation/widgets/note_widget.dart';
import 'package:note_hub/utils/shared_methods.dart';

class SavedNotesScreen extends StatefulWidget {
  const SavedNotesScreen({super.key});

  @override
  State<SavedNotesScreen> createState() => _SavedNotesScreenState();
}

class _SavedNotesScreenState extends State<SavedNotesScreen> {
  @override
  void initState() {
    context.read<SavedNotesBloc>().add(SavedNotesFetched());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BookMarked',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<SavedNotesBloc, SavedNotesState>(
        builder: (context, state) {
          if (state is SavedNotesSuccess) {
            return ConditionalBuilder(
              condition: state.savedNotes.isEmpty,
              builder: (BuildContext context) => Center(
                child: emptyAnimation(),
              ),
              fallback: (BuildContext context) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) => InkWell(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/open_note',
                              arguments: state.savedNotes[index])
                          .then((isChangeOccurred) {
                        if (isChangeOccurred != null &&
                            isChangeOccurred as bool) {
                          if (context.mounted) {
                            context
                                .read<SavedNotesBloc>()
                                .add(SavedNotesFetched());
                          }
                        }
                      });
                    },
                    child: NoteWidget(
                        note: state.savedNotes[index],
                        index: index,
                        isSelected: false),
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10.0),
                  itemCount: state.savedNotes.length,
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }
}
