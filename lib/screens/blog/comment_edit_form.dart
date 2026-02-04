import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/services/comment_provider.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class CommentEditForm extends StatefulWidget {
  const CommentEditForm({
    super.key,
    required this.id,
    required this.body,
    required this.onEditEnd,
  });

  final int id;
  final String body;
  final void Function() onEditEnd;

  @override
  State<CommentEditForm> createState() => _CommentEditFormState();
}

class _CommentEditFormState extends State<CommentEditForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _newBody = '';
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
        children: [
          SizedBox(height: 6),
          StyledFormField(
            label: 'Update',
            isUpdate: true,
            initialValue: widget.body,
            onSaved: (value) => _newBody = value!,
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
          Row(
            children: [
              StyledFilledButton(
                'Update',
                onPressed: () async {
                  if (_formGlobalKey.currentState!.validate()) {
                    _formGlobalKey.currentState!.save();

                    final commentProvider = context.read<CommentProvider>();

                    String? imagePath;

                    if (_image != null) {
                      imagePath = _generateImagePath();
                      await CommentStorageService.addImage(imagePath, _image!);
                    }

                    await commentProvider.updateComment(
                      id: widget.id,
                      body: _newBody,
                      imagePath: imagePath,
                    );

                    widget.onEditEnd();
                  }
                },
              ),
              SizedBox(width: 10),
              StyledFilledButton(
                'Cancel',
                onPressed: widget.onEditEnd,
                color: Colors.red[300],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
