import 'dart:typed_data';
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
import 'package:simple_blog_flutter/utils/generate_image_path.dart';

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
  bool _isSubmitting = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _ext = pickedImage.name.split('.').last.toLowerCase();

      XFile? imageFile = XFile(pickedImage.path);
      _image = await imageFile.readAsBytes();

      if (!mounted) return;

      if (_ext != 'jpg' && _ext != 'jpeg' && _ext != 'png') {
        ScaffoldMessenger.of(context).showSnackBar(
          styledSnackBar(
            isError: true,
            message: 'Please pick a PNG or JPG image!',
          ),
        );
        return;
      }

      setState(() {});
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
                  : Image.memory(
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
