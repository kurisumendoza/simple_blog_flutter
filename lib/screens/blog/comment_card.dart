import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/comment.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';
import 'package:simple_blog_flutter/services/user_provider.dart';
import 'package:simple_blog_flutter/shared/styled_alert_dialog.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
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
                  StyledText(comment.user, color: AppColors.accent),
                ],
              ),
              StyledText(
                '${comment.formattedDate} ${comment.formattedTime}',
                fontSize: 12,
                fontStyle: FontStyle.italic,
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
          if (context.watch<UserProvider>().isLoggedIn &&
              context.read<UserProvider>().username == comment.user)
            Column(
              children: [
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    StyledEditIconButton(onPressed: () {}, size: 20),
                    StyledDeleteIconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => StyledAlertDialog(
                          title: 'Delete Comment',
                          content: StyledText(
                            'Are you sure you want to delete this comment?',
                          ),
                          mainAction: () {},
                          mainActionLabel: 'Delete',
                          mainActionColor: Colors.red[400],
                        ),
                      ),
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
