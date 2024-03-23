import 'package:flutter/material.dart';
import 'package:note_hub/utils/image_picker.dart';

class ImagePickerMethodScreen extends StatefulWidget {
  const ImagePickerMethodScreen({super.key, required this.imagePickerHandler});

  final ImagePickerHandler imagePickerHandler;

  @override
  State<ImagePickerMethodScreen> createState() =>
      _ImagePickerMethodScreenState();
}

class _ImagePickerMethodScreenState extends State<ImagePickerMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                widget.imagePickerHandler.pickOneImageFromCamera();
              },
              child: const Text('Camera')),
          TextButton(
              onPressed: () {
                widget.imagePickerHandler.pickOneImageFromGallery();
              },
              child: const Text('Gallery')),
        ],
      ),
    );
  }
}
