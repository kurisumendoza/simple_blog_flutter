import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/models/comment.dart';
import 'package:simple_blog_flutter/services/comment_service.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    final blog = Provider.of<Blog>(context, listen: false);

    return FutureBuilder(
      future: CommentService.getComments(blog.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final List<Comment> comments = snapshot.data!;
        return SizedBox(
          height: 500,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: comments.length,
            itemBuilder: ((context, index) {
              return Text(comments[index].user);
            }),
          ),
        );
      },
    );
  }
}
