import 'package:intl/intl.dart';

class Profile {
  final int id;
  final DateTime createdAt;
  final String user;
  final String userId;
  final String? bio;
  final String? location;
  final String? imagePath;

  const Profile({
    required this.id,
    required this.createdAt,
    required this.user,
    required this.userId,
    this.bio,
    this.location,
    this.imagePath,
  });

  Profile copyWith({
    int? id,
    DateTime? createdAt,
    String? user,
    String? userId,
    String? bio,
    String? location,
    String? imagePath,
  }) {
    return Profile(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      imagePath: imagePath,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {'bio': bio, 'location': location, 'image_path': imagePath};
  }

  factory Profile.fromSupabase(Map<String, dynamic> data) {
    return Profile(
      id: data['id'] as int,
      createdAt: DateTime.parse(data['created_at']),
      user: data['user'] as String,
      userId: data['user_id'] as String,
      bio: data['bio'],
      location: data['location'],
      imagePath: data['image_path'],
    );
  }

  String get formattedDate => DateFormat.yMMMd().format(createdAt);
}
