import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.lastPage,
  });

  final int currentPage;
  final int lastPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.arrow_left,
          size: 30,
          color: currentPage == 1
              ? AppColors.accent.withValues(alpha: 0.5)
              : AppColors.accent,
        ),
        SizedBox(
          width: 50,
          child: Center(child: StyledHeading('$currentPage')),
        ),
        Icon(
          Icons.arrow_right,
          size: 30,
          color: currentPage == lastPage
              ? AppColors.accent.withValues(alpha: 0.5)
              : AppColors.accent,
        ),
      ],
    );
  }
}
