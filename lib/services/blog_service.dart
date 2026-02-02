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
  static Future<void> createBlog(
    String title,
    String slug,
    String body,
    String user,
    String userId,
    // String? imagePath,
  ) async {
    try {
      await DatabaseService.supabase.from('blogs').insert({
        'title': title,
        'slug': slug,
        'body': body,
        'user': user,
        'user_id': userId,
        // imagePath ?? 'image_path': imagePath,
      });
    } catch (e) {
      rethrow;
    }
  }
}
