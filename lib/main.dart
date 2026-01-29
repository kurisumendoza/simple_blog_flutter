import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    return const MaterialApp(home: HomeScreen());
  }
}
