// lib/main.dart
import 'package:flutter/material.dart';
import 'package:sqflite_supabase_syncing/auth_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://yqzyzqmvyjzffovjoudz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlxenl6cW12eWp6ZmZvdmpvdWR6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ5NjQ0MzYsImV4cCI6MjA1MDU0MDQzNn0.6RXJDE7CwdjGVpAc_91e_t3TXZU37ZDqHy3ZRaBZf6A',
  );

  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Sync Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => AuthScreen(),
        '/tasks': (context) => TaskScreen(),
      },
    );
  }
}