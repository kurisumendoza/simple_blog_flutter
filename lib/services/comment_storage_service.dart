import 'package:simple_blog_flutter/services/database_service.dart';

class CommentStorageService extends DatabaseService {
  // get image URL
  static String getImageUrl(String imagePath) {
    final String publicUrl = DatabaseService.supabase.storage
        .from('comment-images')
        .getPublicUrl(imagePath);

    return publicUrl;
  }
}
