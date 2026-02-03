import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/blog_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:simple_blog_flutter/theme.dart';
import 'package:simple_blog_flutter/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://unlhhcxayjqjbtmyjrzp.supabase.co',
    anonKey: 'sb_publishable_bWqTNNZvw2RZCLcXEjbL3g_DVQAwjmg',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => BlogProvider()),
      ],

      child: MaterialApp(theme: primaryTheme, home: HomeScreen()),
    );
  }
}
