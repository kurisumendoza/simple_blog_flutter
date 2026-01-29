import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/comment.dart';
import 'package:simple_blog_flutter/services/comment_service.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key, required this.blogId});

  final int blogId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CommentService.getComments(blogId),
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
