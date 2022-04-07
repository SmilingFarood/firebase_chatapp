import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  final ImagePicker _imagePicker = ImagePicker();
  File? _userImage;
  try {
    final XFile? _image =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      _userImage = File(_image.path);
    }
    return _userImage;
  } on PlatformException {
    rethrow;
  } catch (e) {
    rethrow;
  }
}
