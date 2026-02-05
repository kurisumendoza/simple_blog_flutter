import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class ProfileStorageService {
  // get image URL
  static String getImageUrl(String imagePath) {
    final String publicUrl = DatabaseService.supabase.storage
        .from('profile-images')
        .getPublicUrl(imagePath);

    return publicUrl;
  }

  // insert new image
  static Future<void> addImage(String fileName, Uint8List file) async {
    await DatabaseService.supabase.storage
        .from('profile-images')
        .uploadBinary(
          fileName,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
  }

  // delete one image
  static Future<void> deleteImage(String filePath) async {
    await DatabaseService.supabase.storage.from('profile-images').remove([
      filePath.trim(),
    ]);
  }
}
