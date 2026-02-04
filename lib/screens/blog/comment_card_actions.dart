import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/services/comment_provider.dart';
import 'package:simple_blog_flutter/shared/styled_alert_dialog.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class CommentCardActions extends StatelessWidget {
  const CommentCardActions({
    super.key,
    required this.onEditStart,
    required this.id,
  });

  final void Function() onEditStart;
  final int id;

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
                    Navigator.pop(context);
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
