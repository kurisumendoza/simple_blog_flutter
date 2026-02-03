import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/screens/blog/comment_section.dart';
import 'package:simple_blog_flutter/screens/update/update_blog_screen.dart';
import 'package:simple_blog_flutter/services/blog_storage_service.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/shared/styled_alert_dialog.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blog = context.read<Blog>();

    return Scaffold(
      appBar: AppBar(title: StyledTitle(blog.title), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (context.watch<AuthProvider>().isLoggedIn &&
                context.read<AuthProvider>().username == blog.user)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StyledEditIconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateBlogScreen(),
                            ),
                          );
                        },
                        size: 28,
                      ),
                      StyledDeleteIconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => StyledAlertDialog(
                            title: 'Delete Blog',
                            content: StyledText(
                              'Are you sure you want to delete this blog?',
                            ),
                            mainAction: () {},
                            mainActionLabel: 'Delete',
                            mainActionColor: Colors.red[400],
                          ),
                        ),
                        size: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            if (blog.imagePath != null)
              Hero(
                tag: blog.id,
                child: Image.network(
                  BlogStorageService.getImageUrl(blog.imagePath!),
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 10),
            StyledHeading(blog.title, fontSize: 20, maxLines: 3),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledRichText(blog.user, fontSize: 16),
                StyledText(
                  '${blog.formattedDate} ${blog.formattedTime}',
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
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
