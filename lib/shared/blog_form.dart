import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_blog_flutter/screens/blog/blog_screen.dart';
import 'package:simple_blog_flutter/screens/home/home_screen.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/blog_provider.dart';
import 'package:simple_blog_flutter/services/blog_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class BlogForm extends StatefulWidget {
  const BlogForm({
    super.key,
    required this.buttonText,
    this.isUpdate = false,
    this.id,
    this.oldTitle,
    this.oldBody,
    this.oldImagePath,
  });

  final String buttonText;
  final bool isUpdate;
  final int? id;
  final String? oldTitle;
  final String? oldBody;
  final String? oldImagePath;

  @override
  State<BlogForm> createState() => _BlogFormState();
}

class _BlogFormState extends State<BlogForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _title = '';
  String _body = '';
  String? _imagePath;
  File? _image;
  bool _isSubmitting = false;

  String _generateSlug() {
    int end = min(_title.length, 30);
    String suffix = Random().nextInt(1000000).toRadixString(36);

    String slug = _title
        .substring(0, end)
        .trim()
        .toLowerCase()
        .split(' ')
        .join('-');

    return '$slug + $suffix';
  }

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
  void initState() {
    if (widget.oldImagePath != null) {
      _imagePath = widget.oldImagePath;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledFormField(
            label: 'Title',
            initialValue: widget.oldTitle,
            onSaved: (value) => _title = value!,
            maxLength: 60,
            minLength: 5,
            lines: 2,
          ),
          SizedBox(height: 15),
          StyledFormField(
            label: 'Body',
            initialValue: widget.oldBody,
            onSaved: (value) => _body = value!,
            maxLength: 1000,
            minLength: 50,
            lines: 16,
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _image == null && _imagePath == null
                  ? StyledText('Add an image')
                  : _imagePath == null
                  ? Image.file(
                      _image!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      BlogStorageService.getImageUrl(_imagePath!),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
              _image == null && _imagePath == null
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
                          _imagePath = null;
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
          SizedBox(height: 30),
          Center(
            child: StyledFilledButton(
              widget.buttonText,
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
                        final blogProvider = context.read<BlogProvider>();
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);

                        String? imagePath = widget.oldImagePath;

                        if (_image != null) {
                          imagePath = _generateImagePath();
                          await BlogStorageService.addImage(imagePath, _image!);

                          if (widget.oldImagePath != null) {
                            await BlogStorageService.deleteImage(
                              widget.oldImagePath!,
                            );
                          }
                        }

                        if (_image == null &&
                            _imagePath == null &&
                            widget.oldImagePath != null) {
                          imagePath = null;
                          await BlogStorageService.deleteImage(
                            widget.oldImagePath!,
                          );
                        }

                        if (!widget.isUpdate) {
                          await blogProvider.createBlog(
                            title: _title.trim(),
                            slug: _generateSlug(),
                            body: _body.trim(),
                            user: authProvider.username!,
                            userId: authProvider.userId!,
                            imagePath: imagePath,
                          );

                          navigator.pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false,
                          );

                          messenger.showSnackBar(
                            styledSnackBar(
                              message: 'Blog posted successfully!',
                            ),
                          );
                        }

                        if (widget.isUpdate) {
                          await blogProvider.updateBlog(
                            id: widget.id!,
                            title: _title.trim(),
                            body: _body.trim(),
                            imagePath: imagePath,
                          );

                          navigator.pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => BlogScreen(id: widget.id),
                            ),
                          );

                          setState(() {
                            _isSubmitting = false;
                          });

                          messenger.showSnackBar(
                            styledSnackBar(
                              message: 'Blog updated successfully!',
                            ),
                          );
                        }
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}
