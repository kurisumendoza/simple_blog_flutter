import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/comment_image.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';

class ImageUploadCarousel extends StatelessWidget {
  ImageUploadCarousel({
    super.key,
    required this.limit,
    required this.imagesList,
    required this.onImageRemove,
  });

  final int limit;
  final List<CommentImage> imagesList;
  final ScrollController _scrollController = ScrollController();
  final void Function(int index) onImageRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: imagesList.length,
            itemBuilder: (context, index) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: imagesList[index].isRemote
                        ? Image.network(
                            CommentStorageService.getImageUrl(
                              imagesList[index].path!,
                            ),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            imagesList[index].file!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: FilledButton(
                      onPressed: () => onImageRemove(index),
                      style: FilledButton.styleFrom(
                        elevation: 5,
                        shape: const CircleBorder(),
                        padding: EdgeInsets.all(5),
                        minimumSize: const Size(20, 20),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.red[400],
                      ),
                      child: Icon(Icons.close, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
