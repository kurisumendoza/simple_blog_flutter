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
import 'package:simple_blog_flutter/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key, this.id});

  final int? id;

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final _controller = PageController();
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final blog = widget.id == null
        ? context.read<Blog>()
        : context.read<BlogProvider>().blogs.firstWhere(
            (b) => b.id == widget.id,
          );

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
                        child: Stack(
                          children: [
                            PageView.builder(
                              itemCount: blog.imagePaths.length,
                              controller: _controller,
                              itemBuilder: (context, index) {
                                final imageUrl = BlogStorageService.getImageUrl(
                                  blog.imagePaths[index],
                                );

                                final image = Image.network(
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
                                );

                                if (index == 0) {
                                  return Hero(tag: blog.id, child: image);
                                } else {
                                  return image;
                                }
                              },
                            ),
                            if (blog.imagePaths.length > 1)
                              Positioned(
                                left: 3,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      _controller.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.keyboard_arrow_left,
                                      color: AppColors.accent,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.background
                                          .withAlpha(120),
                                    ),
                                  ),
                                ),
                              ),
                            if (blog.imagePaths.length > 1)
                              Positioned(
                                right: 3,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      _controller.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.keyboard_arrow_right,
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.background
                                          .withAlpha(120),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 10),

              if (blog.imagePaths.length > 1)
                Center(
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: blog.imagePaths.length,
                    effect: SlideEffect(
                      activeDotColor: AppColors.accent,
                      dotColor: AppColors.secondary,
                      dotHeight: 12,
                      dotWidth: 12,
                    ),
                  ),
                ),

              SizedBox(height: 12),
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
                                    if (_isDeleting) return;

                                    setState(() {
                                      _isDeleting = true;
                                    });

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

                                    if (blog.imagePaths.isNotEmpty) {
                                      for (var path in blog.imagePaths) {
                                        BlogStorageService.deleteImage(path);
                                      }
                                    }

                                    navigator.pop();
                                    navigator.pop();

                                    messenger.showSnackBar(
                                      styledSnackBar(
                                        message: 'Blog successfully deleted!',
                                      ),
                                    );

                                    setState(() {
                                      _isDeleting = false;
                                    });
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
