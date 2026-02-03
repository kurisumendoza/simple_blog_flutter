import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/comment.dart';
import 'package:simple_blog_flutter/services/comment_service.dart';

class CommentProvider extends ChangeNotifier {
  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  Future<void> getComments(int blogId) async {
    List<Comment> comments = await CommentService.getComments(blogId);

    _comments = comments;
  }
}
