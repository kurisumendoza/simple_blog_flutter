import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/screens/blog/comment_form.dart';
import 'package:simple_blog_flutter/screens/blog/comment_list.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      color: AppColors.secondary.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledHeading('Comments'),
          SizedBox(height: 20),
          CommentForm(),
          SizedBox(height: 20),
          CommentList(),
        ],
      ),
    );
  }
}
