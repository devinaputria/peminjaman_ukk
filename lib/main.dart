import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oqpcuhlmflysozrqodpe.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xcGN1aGxtZmx5c296cnFvZHBlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgyNDYwNzgsImV4cCI6MjA4MzgyMjA3OH0.EANglQ0bowD363S4JM1ByZrEwFmavQzbCl9Z86rDb0U',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
