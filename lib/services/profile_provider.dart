import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/profile.dart';
import 'package:simple_blog_flutter/services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  Profile? _profile;
  Profile? get profile => _profile;

  Future<void> getUser(String userId) async {
    final profile = await ProfileService.getUser(userId);

    _profile = profile[0];
  }

  Future<void> createProfile({
    required String username,
    required String userId,
  }) async {
    await ProfileService.createProfile(username: username, userId: userId);
  }

  Future<void> updateProfile({
    required int id,
    String? location,
    String? bio,
    String? imagePath,
  }) async {
    await ProfileService.updateProfile(
      id: id,
      location: location,
      bio: bio,
      imagePath: imagePath,
    );
  }
}
