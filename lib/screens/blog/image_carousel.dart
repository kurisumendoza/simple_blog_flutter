import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/services/comment_storage_service.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel(this.imagesList, {super.key});

  final List<String> imagesList;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: SizedBox(
            height: 75,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.imagesList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Image.network(
                    CommentStorageService.getImageUrl(widget.imagesList[index]),
                    height: 75,
                    width: 75,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
