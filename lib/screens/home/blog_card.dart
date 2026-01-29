import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/services/blog_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({super.key, required this.blog});

  final Blog blog;
  String get formattedDate => DateFormat.yMMMd().format(blog.createdAt);
  String get formattedTime => DateFormat.jm().format(blog.createdAt);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledHeading(blog.title, maxLines: 1),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledRichText(blog.user),
                StyledSmallText('$formattedDate $formattedTime'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (blog.imagePath != null) ...[
                  Image.network(
                    BlogStorageService.getImageUrl(blog.imagePath!),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 15),
                ],
                Expanded(child: StyledPreviewText(blog.body)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      StyledColoredText('Read More', color: AppColors.accent),
                      SizedBox(width: 6),
                      Icon(Icons.read_more, color: AppColors.accent, size: 25),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
