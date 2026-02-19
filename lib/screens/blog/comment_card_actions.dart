import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/services/comment_provider.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_alert_dialog.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class CommentCardActions extends StatelessWidget {
  const CommentCardActions({
    super.key,
    required this.onEditStart,
    required this.id,
    required this.imagePaths,
  });

  final void Function() onEditStart;
  final int id;
  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StyledEditIconButton(onPressed: onEditStart, size: 20),
            StyledDeleteIconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => StyledAlertDialog(
                  title: 'Delete Comment',
                  content: StyledText(
                    'Are you sure you want to delete this comment?',
                  ),
                  mainAction: () {
                    context.read<CommentProvider>().deleteComment(id);

                    if (imagePaths.isNotEmpty) {
                      for (var path in imagePaths) {
                        CommentStorageService.deleteImage(path);
                      }
                    }

                    Navigator.pop(context);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(styledSnackBar(message: 'Comment deleted!'));
                  },
                  mainActionLabel: 'Delete',
                  mainActionColor: Colors.red[400],
                ),
              ),
              size: 24,
            ),
          ],
        ),
      ],
    );
  }
}
