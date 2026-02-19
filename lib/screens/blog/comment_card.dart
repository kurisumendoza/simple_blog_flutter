import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/comment.dart';
import 'package:simple_blog_flutter/screens/blog/comment_card_actions.dart';
import 'package:simple_blog_flutter/screens/blog/comment_edit_form.dart';
import 'package:simple_blog_flutter/screens/blog/image_carousel.dart';
import 'package:simple_blog_flutter/screens/profile/profile_screen.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/profile_provider.dart';
import 'package:simple_blog_flutter/services/profile_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.isEditing,
    required this.onEditStart,
    required this.onEditEnd,
  });

  final Comment comment;
  final bool isEditing;
  final void Function() onEditStart;
  final void Function() onEditEnd;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  void initState() {
    _fetchUserProfile();
    super.initState();
  }

  Future<void> _fetchUserProfile() async {
    await context.read<ProfileProvider>().getUser(widget.comment.userId);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profile = profileProvider.getProfile(widget.comment.userId);
    final userImage = profile?.imagePath;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (context.read<AuthProvider>().isLoggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(userId: widget.comment.userId),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      styledSnackBar(
                        message: 'You have to login to view profiles',
                        isError: true,
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    userImage == null
                        ? Container(
                            height: 30,
                            width: 30,
                            color: AppColors.primary,
                            child: Icon(Icons.person),
                          )
                        : Image.network(
                            ProfileStorageService.getImageUrl(userImage),
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                    SizedBox(width: 5),
                    StyledText(widget.comment.user, color: AppColors.accent),
                  ],
                ),
              ),

              StyledText(
                '${widget.comment.formattedDate} ${widget.comment.formattedTime}',
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ],
          ),
          SizedBox(height: 8),
          widget.isEditing &&
                  (widget.comment.userId ==
                      context.watch<AuthProvider>().user!.id)
              ? CommentEditForm(
                  id: widget.comment.id,
                  oldBody: widget.comment.body,
                  oldImagePath: widget.comment.imagePaths[0],
                  onEditEnd: widget.onEditEnd,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.comment.imagePaths.isNotEmpty)
                      ImageCarousel(widget.comment.imagePaths),
                    SizedBox(height: 6),
                    StyledText(widget.comment.body),
                  ],
                ),
          if (!widget.isEditing &&
              context.watch<AuthProvider>().isLoggedIn &&
              context.read<AuthProvider>().username == widget.comment.user)
            CommentCardActions(
              onEditStart: widget.onEditStart,
              id: widget.comment.id,
              imagePaths: widget.comment.imagePaths,
            ),
        ],
      ),
    );
  }
}
