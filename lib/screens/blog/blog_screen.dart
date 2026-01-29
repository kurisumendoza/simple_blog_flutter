import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/screens/blog/comment_section.dart';
import 'package:simple_blog_flutter/services/blog_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key, required this.blog});

  final Blog blog;
  String get formattedDate => DateFormat.yMMMd().format(blog.createdAt);
  String get formattedTime => DateFormat.jm().format(blog.createdAt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle(blog.title), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (blog.imagePath != null)
              Image.network(
                BlogStorageService.getImageUrl(blog.imagePath!),
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 15),
            StyledHeading(blog.title, maxLines: 3),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledRichText(blog.user, fontSize: 16),
                StyledSmallText('$formattedDate $formattedTime', fontSize: 14),
              ],
            ),
            SizedBox(height: 15),
            StyledText(blog.body),
            SizedBox(height: 30),
            CommentSection(),
          ],
        ),
      ),
    );
  }
}
