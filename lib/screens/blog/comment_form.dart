import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

class CommentForm extends StatefulWidget {
  const CommentForm({super.key});

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _body = '';
  File? _image;

  String _generateImagePath() {
    String ext = _image!.path.split('.').last;
    String pathName = Random().nextInt(1000000).toRadixString(36);

    return 'public/$pathName.$ext';
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;

    if (pickedImage != null) {
      String ext = pickedImage.path.split('.').last.toLowerCase();

      if (ext != 'jpg' && ext != 'jpeg' && ext != 'png') {
        ScaffoldMessenger.of(context).showSnackBar(
          styledSnackBar(
            isError: true,
            message: 'Please pick a PNG or JPG image!',
          ),
        );
        return;
      }

      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

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
                  ? StyledText('Add an image')
                  : Image.file(
                      _image!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
              SizedBox(width: 10),
              _image == null
                  ? OutlinedButton(
                      onPressed: () {
                        pickImage();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: StyledText('Choose File'),
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
            'Post Comment',
            onPressed: () async {
              if (_formGlobalKey.currentState!.validate()) {
                _formGlobalKey.currentState!.save();

                final authProvider = context.read<AuthProvider>();
                final commentProvider = context.read<CommentProvider>();
                final blogContext = context.read<Blog>();

                String? imagePath;

                if (_image != null) {
                  imagePath = _generateImagePath();
                  await CommentStorageService.addImage(imagePath, _image!);
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
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
