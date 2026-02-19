import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/blog.dart';
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
  Uint8List? _image;
  String? _ext;
  List<Uint8List> _images = [];
  List<String> _exts = [];
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
          Row(
            children: [
              _image == null
                  ? StyledText('Add images')
                  : Image.memory(
                      _image!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
              SizedBox(width: 10),
              _image == null
                  ? OutlinedButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final result = await pickMultipleImages(
                          existingCount: _images.length,
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
                          _images.addAll(result.images);
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
                    )
                  : OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _image = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: StyledText('Remove Image', color: Colors.red[200]),
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

                      String? imagePath;

                      if (_image != null) {
                        imagePath = generateImagePath(_ext!);
                        await CommentStorageService.addImage(
                          imagePath,
                          _image!,
                        );
                      }

                      await commentProvider.createComment(
                        body: _body.trim(),
                        user: authProvider.username!,
                        userId: authProvider.userId!,
                        blogId: blogContext.id,
                        imagePath: imagePath,
                      );

                      _formGlobalKey.currentState!.reset();
                      setState(() {
                        _image = null;
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
