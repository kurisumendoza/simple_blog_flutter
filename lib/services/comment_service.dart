import 'package:simple_blog_flutter/models/comment.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class CommentService extends DatabaseService {
  // get all blog comments
  static Future<List<Comment>> getComments(int blogId) async {
    final data = await DatabaseService.supabase
        .from('comments')
        .select()
        .eq('blog_id', blogId)
        .order('created_at');

    return data.map<Comment>((d) => Comment.fromSupabase(d)).toList();
  }

  static Future<List<Comment>> createComment(
    String body,
    String user,
    String userId,
    int blogId,
    // String? imagePath,
  ) async {
    try {
      final data = await DatabaseService.supabase.from('comments').insert({
        'body': body,
        'user': user,
        'user_id': userId,
        'blog_id': blogId,
        // imagePath ?? 'image_path' : imagePath,
      }).select();

      return data.map<Comment>((d) => Comment.fromSupabase(d)).toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Comment>> updateComment(int id, String body) async {
    try {
      final data = await DatabaseService.supabase
          .from('comments')
          .update({'body': body})
          .eq('id', id)
          .select();

      return data.map<Comment>((d) => Comment.fromSupabase(d)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
