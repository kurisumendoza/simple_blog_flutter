import 'package:simple_blog_flutter/models/profile.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class ProfileService {
  // fetch profile details
  static Future<List<Profile>> getUser(String userId) async {
    try {
      final data = await DatabaseService.supabase
          .from('profile')
          .select()
          .eq('user_id', userId);

      return data.map<Profile>((p) => Profile.fromSupabase(p)).toList();
    } catch (e) {
      rethrow;
    }
  }

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

  // update profile details
  static Future<void> updateProfile({
    required int id,
    String? location,
    String? bio,
    String? imagePath,
  }) async {
    try {
      await DatabaseService.supabase
          .from('profile')
          .update({'location': location, 'bio': bio, 'image_path': imagePath})
          .eq('id', id)
          .select();
    } catch (e) {
      rethrow;
    }
  }

  // check if username already exists
  static Future<bool> userExists(String username) async {
    try {
      final user = await DatabaseService.supabase
          .from('profile')
          .select('id')
          .eq('user', username);

      return user.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
