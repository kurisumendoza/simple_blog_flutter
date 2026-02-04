import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/services/blog_service.dart';

class BlogProvider extends ChangeNotifier {
  List<Blog> _blogs = [];
  List<Blog> get blogs => _blogs;

  List<Blog> _userBlogs = [];
  List<Blog> get userBlogs => _userBlogs;

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

  Future<void> getUserBlogs(String userId) async {
    _isLoading = true;

    List<Blog> blogs = await BlogService.getUserBlogs(userId);

    _userBlogs = blogs;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createBlog({
    required String title,
    required String slug,
    required String body,
    required String user,
    required String userId,
    String? imagePath,
  }) async {
    await BlogService.createBlog(
      title: title,
      slug: slug,
      body: body,
      user: user,
      userId: userId,
      imagePath: imagePath,
    );

    notifyListeners();
  }

  Future<void> updateBlog({
    required int id,
    required String title,
    required String body,
    String? imagePath,
  }) async {
    await BlogService.updateBlog(
      id: id,
      title: title,
      body: body,
      imagePath: imagePath,
    );

    final blog = _blogs.firstWhere((b) => b.id == id);
    final int i = _blogs.indexOf(blog);

    _blogs[i] = _blogs[i].copyWith(
      title: title,
      body: body,
      imagePath: imagePath,
    );
    notifyListeners();
  }

  Future<void> deleteBlog(int id) async {
    await BlogService.deleteBlog(id);

    await getBlogs(_lastStart, _lastEnd);

    notifyListeners();
  }
}
