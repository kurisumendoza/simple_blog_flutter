import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/comment.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Container(
                      color: AppColors.primary,
                      child: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(width: 5),
                  StyledColoredText(comment.user, color: AppColors.accent),
                ],
              ),
              StyledSmallText(
                '${comment.formattedDate} ${comment.formattedTime}',
                fontSize: 14,
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyledText(comment.body),
              if (comment.imagePath != null)
                Image.network(
                  CommentStorageService.getImageUrl(comment.imagePath!),
                  height: 75,
                  width: 75,
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
