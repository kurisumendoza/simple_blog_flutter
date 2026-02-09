import 'dart:typed_data';
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
import 'package:simple_blog_flutter/utils/generate_image_path.dart';

class CommentEditForm extends StatefulWidget {
  const CommentEditForm({
    super.key,
    required this.id,
    required this.oldBody,
    required this.onEditEnd,
    this.oldImagePath,
  });

  final int id;
  final String oldBody;
  final void Function() onEditEnd;
  final String? oldImagePath;

  @override
  State<CommentEditForm> createState() => _CommentEditFormState();
}

class _CommentEditFormState extends State<CommentEditForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _body = '';
  String? _imagePath;
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
        children: [
          SizedBox(height: 6),
          StyledFormField(
            label: 'Update',
            isUpdate: true,
            initialValue: widget.oldBody,
            onSaved: (value) => _body = value!,
            maxLength: 100,
            lines: 3,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _image == null && _imagePath == null
                  ? StyledText('Add an image')
                  : _imagePath == null
                  ? Image.memory(
                      _image!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      CommentStorageService.getImageUrl(_imagePath!),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
              SizedBox(width: 10),
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
          SizedBox(height: 10),
          Row(
            children: [
              StyledFilledButton(
                _isSubmitting ? 'Updating...' : 'Update',
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

                          final commentProvider = context
                              .read<CommentProvider>();
                          final messenger = ScaffoldMessenger.of(context);

                          String? imagePath = widget.oldImagePath;

                          if (_image != null) {
                            imagePath = generateImagePath(_ext!);
                            await CommentStorageService.addImage(
                              imagePath,
                              _image!,
                            );

                            if (widget.oldImagePath != null) {
                              await CommentStorageService.deleteImage(
                                widget.oldImagePath!,
                              );
                            }
                          }

                          if (_image == null &&
                              _imagePath == null &&
                              widget.oldImagePath != null) {
                            imagePath = null;
                            await CommentStorageService.deleteImage(
                              widget.oldImagePath!,
                            );
                          }

                          await commentProvider.updateComment(
                            id: widget.id,
                            body: _body,
                            imagePath: imagePath,
                          );

                          setState(() {
                            _isSubmitting = false;
                          });

                          widget.onEditEnd();
                          messenger.showSnackBar(
                            styledSnackBar(message: 'Comment updated!'),
                          );
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
