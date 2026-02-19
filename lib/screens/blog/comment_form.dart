import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/models/comment_image.dart';
import 'package:simple_blog_flutter/screens/blog/image_upload_carousel.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/comment_provider.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';
import 'package:simple_blog_flutter/utils/generate_image_path.dart';
import 'package:simple_blog_flutter/utils/pick_multiple_images.dart';

class CommentForm extends StatefulWidget {
  const CommentForm({super.key});

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _body = '';
  final int _limit = 10;
  final List<CommentImage> _images = [];
  final List<String> _exts = [];
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledFormField(
            label: 'Leave a comment',
            onSaved: (value) => _body = value!,
            maxLength: 100,
            lines: 3,
          ),
          SizedBox(height: 10),

          if (_images.isNotEmpty)
            ImageUploadCarousel(
              limit: _limit,
              imagesList: _images,
              onImageRemove: (index) {
                setState(() {
                  _images.removeAt(index);
                  _exts.removeAt(index);
                });
              },
            ),

          _images.length < _limit
              ? Row(
                  children: [
                    StyledText('Add images'),
                    SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final result = await pickMultipleImages(
                          existingCount: _images.length,
                          limit: _limit,
                        );

                        if (result.withInvalid) {
                          messenger.showSnackBar(
                            styledSnackBar(
                              isError: true,
                              message:
                                  'Some images are not supported (only PNG/JPG allowed).',
                            ),
                          );
                        }

                        setState(() {
                          _images.addAll(
                            result.images
                                .map((image) => CommentImage(file: image))
                                .toList(),
                          );
                          _exts.addAll(result.exts);
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: StyledText('Choose Files'),
                    ),
                  ],
                )
              : Row(
                  children: [
                    StyledText('Remove Images'),
                    SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _images.clear();
                          _exts.clear();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: StyledText('Remove All', color: Colors.red[200]),
                    ),
                  ],
                ),

          SizedBox(height: 10),
          StyledFilledButton(
            _isSubmitting ? 'Posting...' : 'Post Comment',
            onPressed: _isSubmitting
                ? () {
                    if (_isSubmitting) return;
                  }
                : () async {
                    if (_formGlobalKey.currentState!.validate()) {
                      _formGlobalKey.currentState!.save();

                      setState(() {
                        _isSubmitting = true;
                      });

                      final authProvider = context.read<AuthProvider>();
                      final commentProvider = context.read<CommentProvider>();
                      final blogContext = context.read<Blog>();
                      final messenger = ScaffoldMessenger.of(context);

                      List<String> imagePaths = [];

                      if (_images.isNotEmpty) {
                        for (var i = 0; i < _images.length; i++) {
                          String path;

                          path = generateImagePath(_exts[i]);
                          await CommentStorageService.addImage(
                            path,
                            _images[i].file!,
                          );
                          imagePaths.add(path);
                        }
                      }

                      await commentProvider.createComment(
                        body: _body.trim(),
                        user: authProvider.username!,
                        userId: authProvider.userId!,
                        blogId: blogContext.id,
                        imagePaths: imagePaths,
                      );

                      _formGlobalKey.currentState!.reset();
                      setState(() {
                        _images.clear();
                        _exts.clear();
                        _isSubmitting = false;
                      });

                      messenger.showSnackBar(
                        styledSnackBar(message: 'Comment posted!'),
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }
}
