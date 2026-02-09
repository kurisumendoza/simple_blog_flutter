import 'dart:math';

String generateImagePath(String fileExtension) {
  String pathName = Random().nextInt(1000000).toRadixString(36);

  return 'public/$pathName.$fileExtension';
}
