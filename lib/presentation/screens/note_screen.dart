import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:note_hub/bloc/note_bloc/note_bloc.dart';
import 'package:note_hub/data/models/note/modifications/note_settings.dart';
import 'package:note_hub/data/models/note/note.dart';
import 'package:note_hub/data/models/note/note_content_section.dart';
import 'package:note_hub/data/models/note/notes_factory.dart';
import 'package:note_hub/data/repositories/notes_repos/online_notes_repo.dart';
import 'package:note_hub/utils/shared_assets.dart';
import 'package:note_hub/utils/shared_colors.dart';
import 'package:note_hub/utils/shared_methods.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

import '../../bloc/notes_bloc/notes_bloc.dart';
import '../widgets/styles_bottom_sheet.dart';

// ignore: must_be_immutable
class NoteScreen extends StatefulWidget {
  NoteScreen({super.key, this.note});

  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _contentTextEditingController =
      TextEditingController();
  late Note? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen>
    with SingleTickerProviderStateMixin {
  final double mainScreenPadding = 20.0;
  final double titleTextFieldFontSize = 25.0;
  final double contentTextFieldFontSize = 20.0;

  late AnimationController _pinButtonAnimationController;
  bool _isNewNote = true;

  bool _isChanged = false;

  late NoteBloc _noteBloc;

  @override
  void initState() {
    _noteBloc = context.read<NoteBloc>();

    _pinButtonAnimationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addListener(() {
        setState(() {});
      });

    // add initial note data if there is a note exist
    if (widget.note != null) {
      widget._titleTextEditingController.text = widget.note!.title;
      for (var section in widget.note!.content) {
        if (section.sectionType == SectionType.text) {
          widget._contentTextEditingController.text =
              section.content.toString();
        }
      }
      if (widget.note!.isPinned) _pinButtonAnimationController.forward();
      _isNewNote = false;
    } else {
      widget.note = NotesFactory.createDefaultNote();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (widget.note?.noteSettings.backgroundColor != null)
          ? HexColor(widget.note?.noteSettings.backgroundColor ??
              defaultNoteBackgroundColor)
          : Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.note?.noteSettings.noteBackgroundImageName != null)
            Image.asset(
              noteBackgroundImages[
                  widget.note?.noteSettings.noteBackgroundImageName]!,
              fit: BoxFit.fill,
            ),
          Scaffold(
            appBar: _appBar(),
            body: Hero(
              tag: 'create_note',
              child: BlocProvider(
                create: (context) => NotesBloc(OnlineNotesRepository()),
                child: BlocConsumer<NoteBloc, NoteState>(
                  listener: (BuildContext context, NoteState state) {
                    if (state is NoteSavedAsPdfSuccess) {
                      Navigator.pop(context);
                      _onNoteSavedAsPdf(context, state);
                    }

                    if (state is NoteSaved || state is NoteDiscarded) {
                      if (context.mounted) {
                        BlocProvider.of<NotesBloc>(context).add(NotesFetched());
                        Navigator.pop(context, state is NoteSaved);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(defaultSnackBar(state.message));
                      }
                    }
                  },
                  builder: (context, state) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(mainScreenPadding),
                          child: Column(
                            children: [
                              TextField(
                                controller: widget._titleTextEditingController,
                                onChanged: (value) {
                                  _isChanged = true;
                                },
                                style:
                                    TextStyle(fontSize: titleTextFieldFontSize),
                                decoration: const InputDecoration(
                                  hintText: "TITLE",
                                  border: InputBorder.none,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  controller:
                                      widget._contentTextEditingController,
                                  onChanged: (value) {
                                    _isChanged = true;
                                  },
                                  style: TextStyle(
                                      fontSize: contentTextFieldFontSize),
                                  decoration: const InputDecoration(
                                    hintText: "Content",
                                    border: InputBorder.none,
                                  ),
                                  mouseCursor:
                                      MaterialStateMouseCursor.textable,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _bottomAppBar(),
                      ],
                    );
                  },
                ),
              ),
            ),
            backgroundColor: (widget.note!.noteSettings.backgroundColor !=
                        defaultNoteBackgroundColor ||
                    widget.note!.noteSettings.noteBackgroundImageName != null)
                ? Colors.transparent
                : null,
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<dynamic> _onNoteSavedAsPdf(
      BuildContext context, NoteSavedAsPdfSuccess state) {
    return _noteSavedAsPdfDialog(context, state);
  }

  Future<dynamic> _noteSavedAsPdfDialog(
      BuildContext context, NoteSavedAsPdfSuccess state) {
    return showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.5),
      builder: (BuildContext context) => Column(
        children: [
          Lottie.asset('assets/animations/pdf_saved_animation.json',
              repeat: false),
          TextButton(
              onPressed: () async {
                await OpenFilex.open(state.path);
              },
              child: const Text(
                "View PDF",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
        ],
      ),
    );
  }

  void updateNoteSettings(NoteSettings noteSettings) {
    setState(() {
      widget.note!.noteSettings = noteSettings;
    });
  }

  Widget _bottomAppBar() {
    return Container(
      padding: EdgeInsets.zero,
      height: 50,
      // color: Colors.blueGrey.shade50,
      child: Row(
        children: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.add_box_outlined)),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const BeveledRectangleBorder(),
                  builder: (BuildContext context) {
                    return StylesBottomSheet(
                      updateSettingsFunction: updateNoteSettings,
                      initialNoteSettings: widget.note!.noteSettings,
                    );
                  },
                ).then((value) {});
              },
              icon: const Icon(Icons.color_lens_outlined)),
          const Spacer(),
          Text(
            "Edited ${getCurrentTime()}",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.picture_as_pdf_outlined),
                        title: const Text("Save as PDF"),
                        onTap: () {
                          _saveAsPdf(widget.note!);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text("Share"),
                        onTap: () {
                          _shareNote();
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.more_vert_outlined)),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
          onPressed: _onBackButtonClicked, icon: const Icon(Icons.arrow_back)),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              if (widget.note!.isPinned) {
                _pinButtonAnimationController.reverse();
              } else {
                _pinButtonAnimationController.forward();
              }

              widget.note!.isPinned = !widget.note!.isPinned;
            });
          },
          icon: Lottie.asset('assets/animations/pin_animation.json',
              controller: _pinButtonAnimationController, repeat: false),
        ),
      ],
      backgroundColor: (widget.note!.noteSettings.backgroundColor !=
                  defaultNoteBackgroundColor ||
              widget.note!.noteSettings.noteBackgroundImageName != null)
          ? Colors.transparent
          : null,
    );
  }

  void _onBackButtonClicked() {
    if (_isChanged) {
      bool isEmpty = widget._titleTextEditingController.value.text.isEmpty &&
          widget._contentTextEditingController.value.text.isEmpty;
      widget.note!.title = widget._titleTextEditingController.text;

      widget.note!.content = [
        NoteContentSection(
            sectionType: SectionType.text,
            content: widget._contentTextEditingController.text),
      ];

      if (_isNewNote) {
        _noteBloc.add(NoteInserted(
          widget.note!,
          isEmpty,
        ));
      } else {
        _noteBloc.add(NoteUpdated(widget.note!.id, widget.note!, isEmpty));
      }
    } else {
      Navigator.pop(context);
    }
  }

  void _saveAsPdf(Note note) {
    _noteBloc.add(NoteSavedAsPdf(note));
  }

  void _shareNote() async {
    await Share.share(
        '${widget._titleTextEditingController.text}\n\n${widget._contentTextEditingController.text}');
  }
}
