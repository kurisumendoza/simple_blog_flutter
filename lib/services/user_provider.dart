import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  User? get user => AuthService.user;
  String? get username => AuthService.username;
  bool get isLoggedIn => user != null;

  Future<(bool, String)> loginUser(String email, String password) async {
    try {
      await AuthService.loginUser(email, password);
      notifyListeners();

      return (true, 'Welcome, $username!');
    } catch (e) {
      return (false, 'Failed to login!');
    }
  }

  Future<(bool, String)> logoutUser() async {
    try {
      await AuthService.logoutUser();
      notifyListeners();

      return (true, 'Successfully logged out.');
    } catch (e) {
      return (false, 'Failed to logout!');
    }
  }

  Future<(bool, String)> registerUser(
    String email,
    String password,
    String username,
  ) async {
    try {
      await AuthService.registerUser(email, password, username);
      notifyListeners();

      return (true, 'Welcome, $username!');
    } catch (e) {
      return (false, 'Failed to register!');
    }
  }
}
