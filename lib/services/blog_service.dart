import 'package:simple_blog_flutter/services/database_service.dart';

class BlogService extends DatabaseService {
  static Future<List<dynamic>> getBlogs() async {
    final data = await DatabaseService.supabase.from('blogs').select();
    return data;
  }
}
