import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class AuthService {
  // user and username getters
  static User? get user => DatabaseService.supabase.auth.currentUser;
  static String? get username => user?.userMetadata?['user'];

  // login user
  static Future<void> loginUser(String email, String password) async {
    try {
      await DatabaseService.supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // logout user
  static Future<void> logoutUser() async {
    try {
      await DatabaseService.supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // create user
  static Future<void> registerUser(
    String email,
    String password,
    String username,
  ) async {
    try {
      await DatabaseService.supabase.auth.signUp(
        email: email,
        password: password,
        data: {'user': username},
      );
    } catch (e) {
      rethrow;
    }
  }
}
