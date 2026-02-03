import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/comment.dart';
import 'package:simple_blog_flutter/screens/blog/comment_card_actions.dart';
import 'package:simple_blog_flutter/screens/blog/comment_edit_form.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

bool isEditing = false;

class _CommentCardState extends State<CommentCard> {
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
                  StyledText(widget.comment.user, color: AppColors.accent),
                ],
              ),
              StyledText(
                '${widget.comment.formattedDate} ${widget.comment.formattedTime}',
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ],
          ),
          SizedBox(height: 8),
          isEditing &&
                  (widget.comment.userId ==
                      context.watch<AuthProvider>().user!.id)
              ? CommentEditForm(
                  id: widget.comment.id,
                  body: widget.comment.body,
                  onEditEnd: () {
                    setState(() {
                      isEditing = false;
                    });
                  },
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyledText(widget.comment.body),
                    if (widget.comment.imagePath != null)
                      Image.network(
                        CommentStorageService.getImageUrl(
                          widget.comment.imagePath!,
                        ),
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
          if (!isEditing &&
              context.watch<AuthProvider>().isLoggedIn &&
              context.read<AuthProvider>().username == widget.comment.user)
            CommentCardActions(
              onEditStart: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
        ],
      ),
    );
  }
}
