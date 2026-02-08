import 'package:intl/intl.dart';

class Blog {
  final int id;
  final DateTime createdAt;
  final String title;
  final String slug;
  final String body;
  final String user;
  final String userId;
  final List<String> imagePaths;
  final String? imagePath;

  const Blog({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.slug,
    required this.body,
    required this.user,
    required this.userId,
    required this.imagePaths,
    this.imagePath,
  });

  Blog copyWith({
    int? id,
    DateTime? createdAt,
    String? title,
    String? slug,
    String? body,
    String? user,
    String? userId,
    String? imagePath,
    List<String>? imagePaths,
  }) {
    return Blog(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      body: body ?? this.body,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      imagePaths: imagePaths ?? this.imagePaths,
      imagePath: imagePath,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'title': title,
      'slug': slug,
      'body': body,
      'user': user,
      'user_id': userId,
      'image_path': imagePath,
      'image_paths': imagePaths,
    };
  }

  factory Blog.fromSupabase(Map<String, dynamic> data) {
    return Blog(
      id: data['id'] as int,
      createdAt: DateTime.parse(data['created_at']),
      title: data['title'] as String,
      slug: data['slug'] as String,
      body: data['body'] as String,
      user: data['user'] as String,
      userId: data['user_id'] as String,
      imagePaths: (data['image_paths'] as List)
          .map((e) => e as String)
          .toList(),
      imagePath: data['image_path'],
    );
  }

  String get formattedDate => DateFormat.yMMMd().format(createdAt);
  String get formattedTime => DateFormat.jm().format(createdAt);
}
