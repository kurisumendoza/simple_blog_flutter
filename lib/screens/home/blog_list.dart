import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/screens/home/blog_card.dart';
import 'package:simple_blog_flutter/services/blog_provider.dart';

class BlogList extends StatelessWidget {
  const BlogList({super.key});

  @override
  Widget build(BuildContext context) {
    final blogs = context.watch<BlogProvider>().blogs;

    if (blogs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: blogs.length,
      itemBuilder: ((context, index) {
        return BlogCard(blog: blogs[index]);
      }),
    );
  }
}
