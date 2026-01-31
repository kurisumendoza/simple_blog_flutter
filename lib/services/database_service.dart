import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  static final supabase = Supabase.instance.client;

  static User? get user => supabase.auth.currentUser;

  static String? get userName => user?.userMetadata?['user'];
}
