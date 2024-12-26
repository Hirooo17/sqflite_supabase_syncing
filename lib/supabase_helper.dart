// lib/services/supabase_helper.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'task.dart';

class SupabaseHelper {
  static final SupabaseClient client = Supabase.instance.client;

  Future<String> syncTask(Task task) async {
    final response = await client
        .from('tasks')
        .insert({
          'name': task.name,
          'user_id': task.userId,
        })
        .select()
        .single();
    return response['id'];
  }

  Future<List<Map<String, dynamic>>> fetchUserTasks(String userId) async {
    final response = await client
        .from('tasks')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> deleteTask(String supabaseId) async {
    await client.from('tasks').delete().eq('id', supabaseId);
  }
}

