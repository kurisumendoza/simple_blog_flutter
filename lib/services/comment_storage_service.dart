import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class CommentStorageService extends DatabaseService {
  // get image URL
  static String getImageUrl(String imagePath) {
    final String publicUrl = DatabaseService.supabase.storage
        .from('comment-images')
        .getPublicUrl(imagePath);

    return publicUrl;
  }

  // insert new image
  static Future<void> addImage(String fileName, File file) async {
    await DatabaseService.supabase.storage
        .from('comment-images')
        .upload(
          fileName,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
  }

  // delete one image
  static Future<void> deleteImage(String filePath) async {
    await DatabaseService.supabase.storage.from('comment-images').remove([
      filePath.trim(),
    ]);
  }
}
