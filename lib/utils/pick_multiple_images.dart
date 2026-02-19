import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class PickedImages {
  final List<Uint8List> images;
  final List<String> exts;
  final bool withInvalid;

  PickedImages({
    required this.images,
    required this.exts,
    required this.withInvalid,
  });
}

Future<PickedImages> pickMultipleImages({required int existingCount}) async {
  final picker = ImagePicker();
  final pickedImages = await picker.pickMultiImage();

  if (pickedImages.isEmpty) {
    return PickedImages(images: [], exts: [], withInvalid: false);
  }

  final List<Uint8List> images = [];
  final List<String> exts = [];
  final List<String> invalidFiles = [];

  final limit = 10 - (existingCount);

  for (var pickedImage in pickedImages.take(limit)) {
    final ext = pickedImage.name.split('.').last.toLowerCase();
    if (ext != 'jpg' && ext != 'jpeg' && ext != 'png') {
      invalidFiles.add(pickedImage.name);
      continue;
    }

    final imageBytes = await pickedImage.readAsBytes();
    images.add(imageBytes);
    exts.add(ext);
  }

  return PickedImages(
    images: images,
    exts: exts,
    withInvalid: invalidFiles.isNotEmpty,
  );
}
