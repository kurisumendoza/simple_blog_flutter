import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/screens/home/blog_card.dart';
import 'package:simple_blog_flutter/services/blog_service.dart';

class BlogList extends StatelessWidget {
  const BlogList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BlogService.getBlogs(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final List<Blog> blogs = snapshot.data!;
        return ListView.builder(
          itemCount: blogs.length,
          itemBuilder: ((context, index) {
            return BlogCard(blog: blogs[index]);
          }),
        );
      },
    );
  }
}
