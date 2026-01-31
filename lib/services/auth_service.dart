import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class AuthService {
  // user and username getters
  static User? get user => DatabaseService.supabase.auth.currentUser;
  static String? get userName => user?.userMetadata?['user'];

  // login user
  static Future<void> loginUser(String email, String password) async {
    await DatabaseService.supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
}
