import 'package:simple_blog_flutter/services/database_service.dart';

class BlogStorageService extends DatabaseService {
  // get image URL
  static String getImageUrl(String imagePath) {
    final String publicUrl = DatabaseService.supabase.storage
        .from('blog-images')
        .getPublicUrl(imagePath);

    return publicUrl;
  }
}
