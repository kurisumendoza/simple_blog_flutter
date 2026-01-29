import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class BlogService extends DatabaseService {
  // get all blogs
  static Future<List<Blog>> getBlogs() async {
    final data = await DatabaseService.supabase
        .from('blogs')
        .select()
        .order('created_at');

    return data.map<Blog>((d) => Blog.fromSupabase(d)).toList();
  }
}
