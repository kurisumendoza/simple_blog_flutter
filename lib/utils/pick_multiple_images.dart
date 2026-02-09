import 'package:image_picker/image_picker.dart';
import 'package:simple_blog_flutter/models/blog_image.dart';

class PickedImages {
  final List<BlogImage> images;
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

  final List<BlogImage> images = [];
  final List<String> exts = [];
  final List<String> invalidFiles = [];

  final limit = 10 - (existingCount);

  for (var pickedImage in pickedImages.take(limit)) {
    final ext = pickedImage.name.split('.').last.toLowerCase();
    if (ext != 'jpg' && ext != 'jpeg' && ext != 'png') {
      invalidFiles.add(pickedImage.name);
      continue;
    }

    XFile imageFile = XFile(pickedImage.path);
    final imageBytes = await imageFile.readAsBytes();
    images.add(BlogImage(file: imageBytes));
    exts.add(ext);
  }

  return PickedImages(
    images: images,
    exts: exts,
    withInvalid: invalidFiles.isNotEmpty,
  );
}
