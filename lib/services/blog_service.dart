import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class BlogService {
  // get blogs per page
  static Future<List<Blog>> getBlogs(int start, int end) async {
    try {
      final data = await DatabaseService.supabase
          .from('blogs')
          .select()
          .order('created_at')
          .range(start, end);

      return data.map<Blog>((d) => Blog.fromSupabase(d)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // get blogs total count
  static Future<int> getBlogsCount() async {
    try {
      final data = await DatabaseService.supabase
          .from('blogs')
          .select()
          .count();

      return data.count;
    } catch (e) {
      rethrow;
    }
  }

  // create new blog
  static Future<void> createBlog({
    required String title,
    required String slug,
    required String body,
    required String user,
    required String userId,
    String? imagePath,
  }) async {
    try {
      await DatabaseService.supabase.from('blogs').insert({
        'title': title,
        'slug': slug,
        'body': body,
        'user': user,
        'user_id': userId,
        if (imagePath != null) 'image_path': imagePath,
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Blog>> updateBlog(
    int id,
    String title,
    String body,
  ) async {
    try {
      final data = await DatabaseService.supabase
          .from('blogs')
          .update({'title': title, 'body': body})
          .eq('id', id)
          .select();

      return data.map<Blog>((d) => Blog.fromSupabase(d)).toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteBlog(int id) async {
    try {
      await DatabaseService.supabase.from('blogs').delete().eq('id', id);
    } catch (e) {
      rethrow;
    }
  }
}
