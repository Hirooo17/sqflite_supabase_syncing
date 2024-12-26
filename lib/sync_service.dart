// lib/services/sync_service.dart

import 'database_helper.dart';
import 'supabase_helper.dart';

class SyncService {
  final DatabaseHelper dbHelper;
  final SupabaseHelper supabaseHelper;

  SyncService({
    required this.dbHelper,
    required this.supabaseHelper, required String userId,
  });

  Future<void> syncUnsynced() async {
    final unsynced = await dbHelper.getUnsynced("");
    
    for (var task in unsynced) {
      final supabaseId = await supabaseHelper.syncTask(task);
      await dbHelper.markAsSynced(task.id!, supabaseId);
    }
  }
}