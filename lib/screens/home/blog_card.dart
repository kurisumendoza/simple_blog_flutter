import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/blog.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Text(blog.slug);
  }
}
