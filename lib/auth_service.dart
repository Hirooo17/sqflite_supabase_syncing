// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient client = Supabase.instance.client;

  Future<User?> signUp(String email, String password) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
    );
    return response.user;
  }

  Future<User?> signIn(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? getCurrentUser() {
    return client.auth.currentUser;
  }
}