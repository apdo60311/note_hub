import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:note_hub/data/models/note/modifications/note_settings.dart';
import 'package:note_hub/utils/shared_assets.dart';
import 'package:note_hub/utils/shared_colors.dart';

class StylesBottomSheet extends StatefulWidget {
  const StylesBottomSheet({
    super.key,
    required this.updateSettingsFunction,
    required this.initialNoteSettings,
  });

  final Function(NoteSettings) updateSettingsFunction;
  final NoteSettings initialNoteSettings;

  @override
  State<StylesBottomSheet> createState() => _StylesBottomSheetState();
}

class _StylesBottomSheetState extends State<StylesBottomSheet>
    with SingleTickerProviderStateMixin {
  int selectedColorIndex = -1;
  int selectedBackgroundIndex = -1;

  late AnimationController _animationController;
  late Animation<Offset> _colorsTransactionAnimation;
  late Animation<Offset> _imagesTransactionAnimation;

  @override
  void initState() {
    if (widget.initialNoteSettings.noteBackgroundImageName != null) {
      String imageName = widget.initialNoteSettings.noteBackgroundImageName!;
      selectedBackgroundIndex =
          noteBackgroundImages.keys.toList().indexOf(imageName);
    }

    if (widget.initialNoteSettings.backgroundColor != null) {
      String color = widget.initialNoteSettings.backgroundColor!;
      selectedBackgroundIndex = noteBackgroundColors.indexOf(color);
    }

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    Tween<Offset> rightToLeftOffsetTween =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
    Tween<Offset> leftToRightOffsetTween =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero);

    _colorsTransactionAnimation =
        rightToLeftOffsetTween.animate(_animationController);
    _imagesTransactionAnimation =
        leftToRightOffsetTween.animate(_animationController);
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label("Color"),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 35,
            child: SlideTransition(
              position: _colorsTransactionAnimation,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColorIndex = index;
                        widget.initialNoteSettings.backgroundColor =
                            noteBackgroundColors[selectedColorIndex];
                        widget.initialNoteSettings.noteBackgroundImageName =
                            null;
                        widget
                            .updateSettingsFunction(widget.initialNoteSettings);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: (index == selectedColorIndex)
                              ? Border.all(color: Colors.blue, width: 1.5)
                              : null),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor:
                                HexColor(noteBackgroundColors[index]),
                          ),
                          if (index == selectedColorIndex)
                            const Icon(
                              Icons.done,
                              color: Colors.blue,
                              size: 19,
                            )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  width: 10,
                ),
                itemCount: noteBackgroundColors.length,
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          _label("Background"),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 55,
            child: SlideTransition(
              position: _imagesTransactionAnimation,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        debugPrint("clicked");
                        selectedBackgroundIndex = index;
                        widget.initialNoteSettings.noteBackgroundImageName =
                            noteBackgroundImages.keys
                                .elementAt(selectedBackgroundIndex);
                        widget.initialNoteSettings.backgroundColor = null;
                        widget
                            .updateSettingsFunction(widget.initialNoteSettings);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: (index == selectedBackgroundIndex)
                              ? Border.all(color: Colors.blue, width: 1.5)
                              : null),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Image.asset(
                              noteBackgroundImages[
                                  noteBackgroundImages.keys.elementAt(index)]!,
                              fit: BoxFit.fill,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          if (index == selectedBackgroundIndex)
                            const Icon(
                              Icons.done,
                              color: Colors.blue,
                              size: 19,
                            )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  width: 15,
                ),
                itemCount: noteBackgroundImages.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
