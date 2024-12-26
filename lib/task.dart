// lib/models/task.dart
class Task {
  final int? id;
  final String name;
  final String? supabaseId;
  final bool isSynced;
  final String userId;  // Added user ID

  Task({
    this.id,
    required this.name,
    this.supabaseId,
    this.isSynced = false,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'supabase_id': supabaseId,
      'is_synced': isSynced ? 1 : 0,
      'user_id': userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      supabaseId: map['supabase_id'],
      isSynced: map['is_synced'] == 1,
      userId: map['user_id'],
    );
  }
}