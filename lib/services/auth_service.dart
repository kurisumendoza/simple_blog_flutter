import 'package:simple_blog_flutter/services/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class AuthService {
  // user and username getters
  static User? get user => DatabaseService.supabase.auth.currentUser;
  static String? get username => user?.userMetadata?['user'];
  static String? get userId => user?.id;

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
      if (await ProfileService.userExists(username)) {
        throw AuthApiException('Username already taken');
      }

      await DatabaseService.supabase.auth.signUp(
        email: email,
        password: password,
        data: {'user': username},
      );
    } catch (e) {
      rethrow;
    }
  }

  // update user metadata
  static Future<void> updateUser(String username) async {
    try {
      if (await ProfileService.userExists(username)) {
        throw AuthApiException('Username already taken');
      }

      await DatabaseService.supabase.auth.updateUser(
        UserAttributes(data: {'user': username}),
      );
    } catch (e) {
      rethrow;
    }
  }
}
