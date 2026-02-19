import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/services/comment_provider.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';
import 'package:simple_blog_flutter/utils/generate_image_path.dart';
import 'package:simple_blog_flutter/utils/pick_multiple_images.dart';

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
  List<Uint8List> _images = [];
  List<String> _exts = [];
  bool _isSubmitting = false;

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
                  ? StyledText('Add images')
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
