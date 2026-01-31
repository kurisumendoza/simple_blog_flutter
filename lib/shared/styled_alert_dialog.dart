import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class StyledAlertDialog extends StatefulWidget {
  const StyledAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.mainAction,
    this.mainActionColor,
  });

  final String title;
  final String content;
  final void Function() mainAction;
  final Color? mainActionColor;

  @override
  State<StyledAlertDialog> createState() => _StyledAlertDialogState();
}

class _StyledAlertDialogState extends State<StyledAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: StyledTitle(widget.title),
      content: StyledText(widget.content),
      actions: [
        StyledFilledButton(
          'Delete',
          onPressed: widget.mainAction,
          color: widget.mainActionColor,
        ),
        StyledFilledButton('Cancel', onPressed: () => Navigator.pop(context)),
      ],
      backgroundColor: AppColors.secondary,
    );
  }
}
