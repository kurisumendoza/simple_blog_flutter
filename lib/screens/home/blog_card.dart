import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

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
              children: [
                Expanded(child: StyledRichText(blog.user)),
                StyledSmallText('$formattedDate $formattedTime'),
              ],
            ),
            SizedBox(height: 10),
            Row(children: [Expanded(child: StyledPreviewText(blog.body))]),
          ],
        ),
      ),
    );
  }
}
