import 'package:intl/intl.dart';

class Comment {
  final int id;
  final int blogId;
  final DateTime createdAt;
  final String body;
  final String user;
  final String userId;
  final String? imagePath;

  const Comment({
    required this.id,
    required this.blogId,
    required this.createdAt,
    required this.body,
    required this.user,
    required this.userId,
    this.imagePath,
  });

  Comment copyWith({
    int? id,
    int? blogId,
    DateTime? createdAt,
    String? body,
    String? user,
    String? userId,
    String? imagePath,
  }) {
    return Comment(
      id: id ?? this.id,
      blogId: blogId ?? this.blogId,
      createdAt: createdAt ?? this.createdAt,
      body: body ?? this.body,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      imagePath: imagePath,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'blog_id': blogId,
      'body': body,
      'user': user,
      'user_id': userId,
      'image_path': imagePath,
    };
  }

  factory Comment.fromSupabase(Map<String, dynamic> data) {
    return Comment(
      id: data['id'] as int,
      blogId: data['blog_id'] as int,
      createdAt: DateTime.parse(data['created_at']),
      body: data['body'] as String,
      user: data['user'] as String,
      userId: data['user_id'] as String,
      imagePath: data['image_path'],
    );
  }

  String get formattedDate => DateFormat.yMMMd().format(createdAt);
  String get formattedTime => DateFormat.jm().format(createdAt);
}
