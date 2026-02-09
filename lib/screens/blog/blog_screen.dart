import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/screens/blog/comment_section.dart';
import 'package:simple_blog_flutter/screens/update/update_blog_screen.dart';
import 'package:simple_blog_flutter/services/blog_provider.dart';
import 'package:simple_blog_flutter/services/blog_storage_service.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/comment_provider.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';
import 'package:simple_blog_flutter/shared/owner_label.dart';
import 'package:simple_blog_flutter/shared/styled_alert_dialog.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class BlogScreen extends StatelessWidget {
  BlogScreen({super.key, this.id});

  final int? id;
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final blog = id == null
        ? context.read<Blog>()
        : context.watch<BlogProvider>().blogs.firstWhere((b) => b.id == id);

    return Provider.value(
      value: blog,
      child: Scaffold(
        appBar: AppBar(
          title: StyledHeading(blog.title),
          actions: [SizedBox(width: kToolbarHeight)],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (blog.imagePaths.isNotEmpty)
                Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth = 500.0;
                      final size = constraints.maxWidth > maxWidth
                          ? maxWidth
                          : constraints.maxWidth;

                      return SizedBox(
                        width: size,
                        height: size,
                        child: PageView.builder(
                          itemCount: blog.imagePaths.length,
                          controller: _controller,
                          itemBuilder: (context, index) {
                            final imageUrl = BlogStorageService.getImageUrl(
                              blog.imagePaths[index],
                            );

                            final image = Stack(
                              children: [
                                Image.network(
                                  imageUrl,
                                  width: size,
                                  height: size,
                                  fit: BoxFit.cover,
                                  frameBuilder: (context, child, frame, _) {
                                    if (frame == null) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    return child;
                                  },
                                ),
                              ],
                            );

                            if (index == 0) {
                              return Hero(tag: blog.id, child: image);
                            } else {
                              return image;
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),

              SizedBox(height: 10),
              StyledHeading(blog.title, fontSize: 20, maxLines: 3),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OwnerLabel(
                    username: blog.user,
                    userId: blog.userId,
                    fontSize: 16,
                  ),
                  StyledText(
                    '${blog.formattedDate} ${blog.formattedTime}',
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ],
              ),
              context.watch<AuthProvider>().isLoggedIn &&
                      context.read<AuthProvider>().username == blog.user
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            StyledEditIconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateBlogScreen(blog),
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
                                  mainAction: () async {
                                    final blogProvider = context
                                        .read<BlogProvider>();
                                    final commentProvider = context
                                        .read<CommentProvider>();
                                    final navigator = Navigator.of(context);
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );

                                    await blogProvider.deleteBlog(blog.id);

                                    final data = await commentProvider
                                        .deleteAllComments(blog.id);

                                    for (final comment in data) {
                                      final path = comment['image_path'];
                                      if (path != null) {
                                        await CommentStorageService.deleteImage(
                                          path,
                                        );
                                      }
                                    }

                                    if (blog.imagePaths.isEmpty) {
                                      BlogStorageService.deleteImage(
                                        blog.imagePaths[0],
                                      );
                                    }

                                    navigator.pop();
                                    navigator.pop();

                                    messenger.showSnackBar(
                                      styledSnackBar(
                                        message: 'Blog successfully deleted!',
                                      ),
                                    );
                                  },
                                  mainActionLabel: 'Delete',
                                  mainActionColor: Colors.red[400],
                                ),
                              ),
                              size: 30,
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(height: 16),
              StyledText(blog.body),
              SizedBox(height: 30),
              CommentSection(),
            ],
          ),
        ),
      ),
    );
  }
}
