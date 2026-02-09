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

  // get recent blogs by user
  static Future<List<Blog>> getUserBlogs(String userId) async {
    try {
      final data = await DatabaseService.supabase
          .from('blogs')
          .select()
          .eq('user_id', userId)
          .order('created_at')
          .range(0, 4);

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
    required List<String> imagePaths,
  }) async {
    try {
      await DatabaseService.supabase.from('blogs').insert({
        'title': title,
        'slug': slug,
        'body': body,
        'user': user,
        'user_id': userId,
        'image_paths': imagePaths,
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Blog>> updateBlog({
    required int id,
    required String title,
    required String body,
    required List<String> imagePaths,
  }) async {
    try {
      final data = await DatabaseService.supabase
          .from('blogs')
          .update({'title': title, 'body': body, 'image_paths': imagePaths})
          .eq('id', id)
          .select();

      return data.map<Blog>((d) => Blog.fromSupabase(d)).toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateBlogsUser({
    required String userId,
    required String user,
  }) async {
    try {
      await DatabaseService.supabase
          .from('blogs')
          .update({'user': user})
          .eq('user_id', userId)
          .select();
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
