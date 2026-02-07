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
    required this.mainActionLabel,
    this.mainActionColor,
  });

  final String title;
  final Widget content;
  final void Function() mainAction;
  final String mainActionLabel;
  final Color? mainActionColor;

  @override
  State<StyledAlertDialog> createState() => _StyledAlertDialogState();
}

class _StyledAlertDialogState extends State<StyledAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: StyledHeading(widget.title),
      content: widget.content,
      actions: [
        StyledFilledButton(
          widget.mainActionLabel,
          onPressed: widget.mainAction,
          color: widget.mainActionColor,
        ),
        StyledFilledButton('Cancel', onPressed: () => Navigator.pop(context)),
      ],
      backgroundColor: AppColors.secondary,
    );
  }
}
