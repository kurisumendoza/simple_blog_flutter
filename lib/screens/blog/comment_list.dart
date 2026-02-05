import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/screens/blog/comment_card.dart';
import 'package:simple_blog_flutter/services/comment_provider.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class CommentList extends StatefulWidget {
  const CommentList({super.key});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  void initState() {
    _loadComments();
    super.initState();
  }

  Future<void> _loadComments() async {
    int blogId = context.read<Blog>().id;
    await context.read<CommentProvider>().getComments(blogId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (context, value, child) {
        if (value.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (value.comments.isEmpty) {
          return Align(
            alignment: Alignment.centerLeft,
            child: StyledText('No comments yet'),
          );
        }

        return ListView.separated(
          itemCount: value.comments.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: ((context, index) {
            return CommentCard(
              key: ValueKey(value.comments[index].id),
              comment: value.comments[index],
            );
          }),
        );
      },
    );
  }
}
