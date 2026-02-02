import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/services/blog_service.dart';

class BlogProvider extends ChangeNotifier {
  List<Blog> _blogs = [];
  List<Blog> get blogs => _blogs;

  int _count = 0;
  int get count => _count;

  Future<void> getBlogs(int start, int end) async {
    List<Blog> blogs = await BlogService.getBlogs(start, end);

    int count = await BlogService.getBlogsCount();

    _blogs = blogs;
    _count = count;

    notifyListeners();
  }

  Future<void> createBlog(
    String title,
    String slug,
    String body,
    String user,
    String userId,
    // String? imagePath,
  ) async {
    await BlogService.createBlog(
      title,
      slug,
      body,
      user,
      userId,
      // imagePath ?? 'image_path' : imagePath,
    );

    notifyListeners();
  }
}
