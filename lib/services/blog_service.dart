import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/services/database_service.dart';

class BlogService extends DatabaseService {
  // get blogs per page
  static Future<List<Blog>> getBlogs(int start, int end) async {
    final data = await DatabaseService.supabase
        .from('blogs')
        .select()
        .order('created_at')
        .range(start, end);

    return data.map<Blog>((d) => Blog.fromSupabase(d)).toList();
  }

  // get blogs total count
  static Future<int> getBlogsCount() async {
    final data = await DatabaseService.supabase.from('blogs').select().count();

    return data.count;
  }
}
