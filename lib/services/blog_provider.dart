import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/services/blog_service.dart';

class BlogProvider extends ChangeNotifier {
  List<Blog> _blogs = [];
  List<Blog> get blogs => _blogs;

  int _count = 0;
  int get count => _count;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int _lastStart = 0;
  int _lastEnd = 4;

  Future<void> getBlogs(int start, int end) async {
    _isLoading = true;
    _lastStart = start;
    _lastEnd = end;

    List<Blog> blogs = await BlogService.getBlogs(start, end);

    int count = await BlogService.getBlogsCount();

    _blogs = blogs;
    _count = count;

    _isLoading = false;
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

  Future<void> updateBlog(int id, String title, String body) async {
    await BlogService.updateBlog(id, title, body);

    final blog = _blogs.firstWhere((b) => b.id == id);
    final int i = _blogs.indexOf(blog);

    _blogs[i] = _blogs[i].copyWith(title: title, body: body);
    notifyListeners();
  }

  Future<void> deleteBlog(int id) async {
    await BlogService.deleteBlog(id);

    await getBlogs(_lastStart, _lastEnd);

    notifyListeners();
  }
}
