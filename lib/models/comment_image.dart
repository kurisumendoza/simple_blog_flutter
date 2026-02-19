import 'dart:typed_data';

class CommentImage {
  final String? path;
  final Uint8List? file;

  CommentImage({this.path, this.file});

  bool get isRemote => path != null;
  bool get isLocal => file != null;
}
