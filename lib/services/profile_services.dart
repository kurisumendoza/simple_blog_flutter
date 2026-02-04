import 'package:simple_blog_flutter/services/database_service.dart';

class ProfileServices {
  // create profile details on register
  static Future<void> createProfile({
    required String username,
    required String userId,
  }) async {
    try {
      await DatabaseService.supabase.from('profile').insert({
        'user': username,
        'user_id': userId,
      });
    } catch (e) {
      rethrow;
    }
  }
}
