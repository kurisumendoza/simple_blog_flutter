import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle(blog.title), centerTitle: true),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(),
      ),
    );
  }
}
