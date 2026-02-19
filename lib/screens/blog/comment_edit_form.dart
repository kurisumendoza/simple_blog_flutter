import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/comment_image.dart';
import 'package:simple_blog_flutter/screens/blog/image_upload_carousel.dart';
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
    required this.oldImagePaths,
  });

  final int id;
  final String oldBody;
  final void Function() onEditEnd;
  final List<String> oldImagePaths;

  @override
  State<CommentEditForm> createState() => _CommentEditFormState();
}

class _CommentEditFormState extends State<CommentEditForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _body = '';
  final int _limit = 10;
  final List<CommentImage> _images = [];
  final List<String> _exts = [];
  int _remoteImagesCount = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    if (widget.oldImagePaths.isNotEmpty) {
      _images.addAll(
        widget.oldImagePaths.map((path) => CommentImage(path: path)),
      );
      _remoteImagesCount = widget.oldImagePaths.length;
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

          if (_images.isNotEmpty)
            ImageUploadCarousel(
              limit: _limit,
              imagesList: _images,
              onImageRemove: (index) {
                setState(() {
                  if (_images[index].isRemote) {
                    _images.removeAt(index);
                    _remoteImagesCount--;
                  } else {
                    _images.removeAt(index);
                    _exts.removeAt(index - _remoteImagesCount);
                  }
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
                          limit: 10,
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
                          _remoteImagesCount = 0;
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

                          List<String> imagePaths = [];
                          // no _exts (extension) entry for remote images
                          int remoteImages = 0;

                          if (_images.isNotEmpty) {
                            for (var i = 0; i < _images.length; i++) {
                              String path;

                              if (_images[i].isRemote) {
                                path = _images[i].path!;
                                remoteImages++;
                              } else {
                                path = generateImagePath(
                                  _exts[i - (remoteImages)],
                                );
                                await CommentStorageService.addImage(
                                  path,
                                  _images[i].file!,
                                );
                              }

                              imagePaths.add(path);
                            }
                          }

                          if (widget.oldImagePaths.isNotEmpty) {
                            for (var oldPath in widget.oldImagePaths) {
                              bool isKept = _images.any(
                                (img) => img.isRemote && img.path == oldPath,
                              );

                              if (!isKept) {
                                await CommentStorageService.deleteImage(
                                  oldPath,
                                );
                              }
                            }
                          }

                          if (_images.isEmpty &&
                              widget.oldImagePaths.isNotEmpty) {
                            for (var oldPath in widget.oldImagePaths) {
                              await CommentStorageService.deleteImage(oldPath);
                            }
                          }

                          await commentProvider.updateComment(
                            id: widget.id,
                            body: _body,
                            imagePaths: imagePaths,
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
