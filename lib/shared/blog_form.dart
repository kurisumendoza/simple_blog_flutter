import 'dart:math';
import 'dart:typed_data';
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
    required this.oldImagePaths,
    this.isUpdate = false,
    this.id,
    this.oldTitle,
    this.oldBody,
  });

  final String buttonText;
  final List<String> oldImagePaths;
  final bool isUpdate;
  final int? id;
  final String? oldTitle;
  final String? oldBody;

  @override
  State<BlogForm> createState() => _BlogFormState();
}

class _BlogFormState extends State<BlogForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _title = '';
  String _body = '';
  bool _isSubmitting = false;
  final List<String> _imagePaths = [];
  final List<Uint8List> _images = [];
  final List<String> _exts = [];

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

  // String _generateImagePath(String ext) {
  //   String pathName = Random().nextInt(1000000).toRadixString(36);

  //   return 'public/$pathName.$ext';
  // }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(limit: 2);

    if (pickedImages.isNotEmpty) {
      List<Uint8List> images = [];
      List<String> exts = [];
      List<String> invalidFiles = [];

      final limit = 10 - (_imagePaths.length + _images.length);

      for (var pickedImage in pickedImages.take(limit)) {
        final ext = pickedImage.name.split('.').last.toLowerCase();
        if (ext != 'jpg' && ext != 'jpeg' && ext != 'png') {
          invalidFiles.add(pickedImage.name);
          continue;
        }

        XFile imageFile = XFile(pickedImage.path);
        final imageBytes = await imageFile.readAsBytes();
        images.add(imageBytes);
        exts.add(ext);
      }

      if (!mounted) return;

      if (invalidFiles.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          styledSnackBar(
            isError: true,
            message: 'Some images are not supported (only PNG/JPG allowed)',
          ),
        );
      }

      setState(() {
        _images.addAll(images);
        _exts.addAll(exts);
      });
    }
  }

  @override
  void initState() {
    if (widget.oldImagePaths.isNotEmpty) {
      _imagePaths.addAll(widget.oldImagePaths);
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
            lines: 1,
          ),
          SizedBox(height: 15),
          StyledFormField(
            label: 'Body',
            initialValue: widget.oldBody,
            onSaved: (value) => _body = value!,
            maxLength: 1000,
            minLength: 50,
            lines: 10,
          ),
          SizedBox(height: 15),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _imagePaths.length + _images.length,
            itemBuilder: (context, index) {
              return _imagePaths.length > index
                  ? Image.network(
                      BlogStorageService.getImageUrl(_imagePaths[index]),
                      fit: BoxFit.cover,
                    )
                  : Image.memory(
                      _images[index - _imagePaths.length],
                      fit: BoxFit.cover,
                    );
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _images.isEmpty && _imagePaths.isEmpty
                  ? StyledText('Add images')
                  : (_images.length + _imagePaths.length) < 10
                  ? StyledText('Add more')
                  : StyledText('Remove all'),

              (_images.length + _imagePaths.length) >= 10
                  ? OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _images.clear();
                          _imagePaths.clear();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: StyledText(
                        'Remove Images',
                        color: Colors.red[200],
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () {
                        _pickImages();
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
          ),
          SizedBox(height: 15),
          StyledText('You can add up to 10 images.', fontSize: 12),
          StyledText('Only PNG and JPEG allowed!', fontSize: 12),
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

                        String? imagePath = widget.oldImagePaths[0];

                        // if (_images.isNotEmpty) {
                        //   imagePath = _generateImagePath();
                        //   await BlogStorageService.addImage(
                        //     imagePath,
                        //     _images[0],
                        //   );

                        //   if (widget.oldImagePaths.isNotEmpty) {
                        //     await BlogStorageService.deleteImage(
                        //       widget.oldImagePaths[0],
                        //     );
                        //   }
                        // }

                        if (_images.isEmpty &&
                            _imagePaths.isEmpty &&
                            widget.oldImagePaths.isNotEmpty) {
                          imagePath = null;
                          await BlogStorageService.deleteImage(
                            widget.oldImagePaths[0],
                          );
                        }

                        if (!widget.isUpdate) {
                          await blogProvider.createBlog(
                            title: _title.trim(),
                            slug: _generateSlug(),
                            body: _body.trim(),
                            user: authProvider.username!,
                            userId: authProvider.userId!,
                            imagePaths: [imagePath!],
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
                            imagePaths: [imagePath!],
                          );

                          navigator.pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => BlogScreen(id: widget.id),
                            ),
                            (route) => route.isFirst,
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
