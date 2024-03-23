import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerHandler {
  final ImagePicker _imagePicker = ImagePicker();

  final List<File> _pickedFiles = [];

  List<File> get pickedFiles => _pickedFiles;

  void pickOneImageFromGallery() async {
    freeFilesList();
    _handlePermissions();
    XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    _pickedFiles.add(File(pickedFile!.path));
  }

  void pickOneImageFromCamera() async {
    freeFilesList();
    _handlePermissions();
    XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);
    _pickedFiles.add(File(pickedFile!.path));
  }

  void pickImages() async {
    freeFilesList();
    _handlePermissions();
    List<XFile> pickedImages = await _imagePicker.pickMultiImage();

    for (var image in pickedImages) {
      _pickedFiles.add(File(image.path));
    }
  }

  void freeFilesList() {
    _pickedFiles.removeRange(0, _pickedFiles.length);
  }

  void _handlePermissions() async {
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
  }
}
