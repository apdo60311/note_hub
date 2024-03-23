import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:note_hub/data/models/note/note.dart';
import 'package:note_hub/data/models/note/note_content_section.dart';
import 'package:note_hub/data/models/note/textual_note.dart';
import 'package:note_hub/utils/shared_colors.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({
    super.key,
    required Note note,
    required this.index,
    required this.isSelected,
  }) : _note = note as TextualNote;

  final TextualNote _note;
  final int index;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (_note.noteSettings.noteItemColor != null)
            ? HexColor(_note.noteSettings.noteItemColor ?? "")
            : noteColors[index % noteColors.length],
        borderRadius: BorderRadius.circular(10.0),
        border: (isSelected)
            ? Border.all(color: Colors.blue, width: 2)
            : Border.all(color: Colors.transparent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _note.title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              overflow: TextOverflow.fade,
              maxLines: 2,
            ),
            const SizedBox(height: 5.0),
            Text(
              (_note.content.first.sectionType == SectionType.text)
                  ? _note.content.first.content.toString()
                  : "...",
              style: const TextStyle(color: Colors.black),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
