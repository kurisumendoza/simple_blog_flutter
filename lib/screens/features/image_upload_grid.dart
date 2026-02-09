import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/blog_image.dart';
import 'package:simple_blog_flutter/services/blog_storage_service.dart';
import 'package:simple_blog_flutter/theme.dart';

class ImageUploadGrid extends StatelessWidget {
  const ImageUploadGrid({
    super.key,
    this.coverImage,
    required this.imagesList,
    required this.onImageTap,
    required this.onImageRemove,
  });

  final BlogImage? coverImage;
  final List<BlogImage> imagesList;
  final void Function(int index) onImageTap;
  final void Function(int index) onImageRemove;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6,
        mainAxisSpacing: 10,
      ),
      itemCount: imagesList.length,
      itemBuilder: (context, index) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () => onImageTap(index),
              child: Container(
                decoration: BoxDecoration(
                  border: coverImage == imagesList[index]
                      ? Border.all(color: AppColors.accent, width: 4)
                      : Border.all(color: Colors.transparent, width: 4),
                ),
                child: imagesList[index].isRemote
                    ? Image.network(
                        BlogStorageService.getImageUrl(imagesList[index].path!),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.memory(
                        imagesList[index].file!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Positioned(
              top: -3,
              right: -3,
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
    );
  }
}
