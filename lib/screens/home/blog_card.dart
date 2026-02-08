import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/screens/blog/blog_screen.dart';
import 'package:simple_blog_flutter/services/blog_storage_service.dart';
import 'package:simple_blog_flutter/shared/owner_label.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledHeading(blog.title, maxLines: 1),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OwnerLabel(username: blog.user, userId: blog.userId),
                StyledText(
                  '${blog.formattedDate} ${blog.formattedTime}',
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (blog.imagePath != null) ...[
                  Hero(
                    tag: blog.id,
                    child: Image.network(
                      BlogStorageService.getImageUrl(blog.imagePath!),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Provider.value(value: blog, child: BlogScreen()),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      StyledHeading(
                        'Read More',
                        color: AppColors.accent,
                        fontSize: 14,
                      ),
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
