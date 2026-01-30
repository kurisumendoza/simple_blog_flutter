import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class StyledFilledButton extends StatelessWidget {
  const StyledFilledButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.color,
  });

  final String text;
  final void Function() onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: color ?? AppColors.primary,
      ),
      child: StyledHeading(text),
    );
  }
}
