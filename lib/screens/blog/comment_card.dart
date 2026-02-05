import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/comment.dart';
import 'package:simple_blog_flutter/screens/blog/comment_card_actions.dart';
import 'package:simple_blog_flutter/screens/blog/comment_edit_form.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/profile_provider.dart';
import 'package:simple_blog_flutter/services/profile_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _isEditing = false;
  String? _userImage;

  @override
  void initState() {
    _fetchUserImage();
    super.initState();
  }

  Future<void> _fetchUserImage() async {
    final userImage = await context.read<ProfileProvider>().getUserImage(
      widget.comment.userId.trim(),
    );

    setState(() {
      _userImage = userImage;
    });
  }

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
                  _userImage == null
                      ? Container(
                          height: 30,
                          width: 30,
                          color: AppColors.primary,
                          child: Icon(Icons.person),
                        )
                      : Image.network(
                          ProfileStorageService.getImageUrl(_userImage!),
                          height: 30,
                          width: 30,
                          fit: BoxFit.cover,
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
          _isEditing &&
                  (widget.comment.userId ==
                      context.watch<AuthProvider>().user!.id)
              ? CommentEditForm(
                  id: widget.comment.id,
                  oldBody: widget.comment.body,
                  oldImagePath: widget.comment.imagePath,
                  onEditEnd: () {
                    setState(() {
                      _isEditing = false;
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
          if (!_isEditing &&
              context.watch<AuthProvider>().isLoggedIn &&
              context.read<AuthProvider>().username == widget.comment.user)
            CommentCardActions(
              onEditStart: () {
                setState(() {
                  _isEditing = true;
                });
              },
              id: widget.comment.id,
              imagePath: widget.comment.imagePath,
            ),
        ],
      ),
    );
  }
}
