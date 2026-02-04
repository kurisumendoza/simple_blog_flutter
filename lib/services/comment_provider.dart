import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/comment.dart';
import 'package:simple_blog_flutter/services/comment_service.dart';

class CommentProvider extends ChangeNotifier {
  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> getComments(int blogId) async {
    _isLoading = true;

    List<Comment> comments = await CommentService.getComments(blogId);

    _comments = comments;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createComment(
    String body,
    String user,
    String userId,
    int blogId,
    // String? imagePath,
  ) async {
    List<Comment> comment = await CommentService.createComment(
      body,
      user,
      userId,
      blogId,
      // imagePath ?? 'image_path' : imagePath,
    );

    _comments.insert(0, comment[0]);

    notifyListeners();
  }

  Future<void> updateComment(int id, String body) async {
    await CommentService.updateComment(id, body);

    final comment = _comments.firstWhere((c) => c.id == id);
    final int i = _comments.indexOf(comment);

    _comments[i] = _comments[i].copyWith(body: body);
    notifyListeners();
  }

  Future<void> deleteComment(int id) async {
    await CommentService.deleteComment(id);

    _comments.removeWhere((c) => c.id == id);

    notifyListeners();
  }
}
