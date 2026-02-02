import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/services/blog_service.dart';

class BlogProvider extends ChangeNotifier {
  List<Blog> _blogs = [];
  List<Blog> get blogs => _blogs;

  int _count = 0;
  int get count => _count;

  Future<bool> getBlogs(int start, int end) async {
    try {
      _blogs = await BlogService.getBlogs(start, end);
      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getBlogsCount() async {
    try {
      _count = await BlogService.getBlogsCount();
    } catch (e) {
      _count = -1;
    }
  }
}
