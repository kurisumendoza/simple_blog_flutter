import 'dart:typed_data';

class BlogImage {
  final String? path;
  final Uint8List? file;

  BlogImage({this.path, this.file});

  bool get isRemote => path != null;
  bool get isLocal => file != null;
}
