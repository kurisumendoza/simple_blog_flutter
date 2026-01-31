import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  User? get user => AuthService.user;
  String? get username => AuthService.username;
  bool get isLoggedIn => user != null;

  Future<void> loginUser(String email, String password) async {
    await AuthService.loginUser(email, password);
    notifyListeners();
  }

  Future<void> logoutUser() async {
    await AuthService.logoutUser();
    notifyListeners();
  }
}
