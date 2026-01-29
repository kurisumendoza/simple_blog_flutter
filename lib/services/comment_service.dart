import 'package:simple_blog_flutter/models/comment.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class CommentService extends DatabaseService {
  // get all blog comments
  static Future<List<Comment>> getComments(int blogId) async {
    final data = await DatabaseService.supabase
        .from('comments')
        .select()
        .eq('blog_id', blogId)
        .order('created_at', ascending: true);

    return data.map<Comment>((d) => Comment.fromSupabase(d)).toList();
  }
}
