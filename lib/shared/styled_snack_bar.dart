import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

SnackBar styledSnackBar({required String message, bool isError = false}) {
  return SnackBar(
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16),
    backgroundColor: isError ? Colors.red[400] : AppColors.accent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    content: StyledText(message),
  );
}
