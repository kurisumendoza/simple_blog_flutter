import 'package:simple_blog_flutter/models/profile.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class ProfileService {
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
}
