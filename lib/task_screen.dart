// lib/screens/task_screen.dart
import 'package:flutter/material.dart';
import 'package:sqflite_supabase_syncing/supabase_helper.dart';
import 'task.dart';
import 'database_helper.dart';
import 'sync_service.dart';
import 'auth_service.dart';


class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _controller = TextEditingController();
  final _dbHelper = DatabaseHelper.instance;
  final _authService = AuthService();
  late SyncService _syncService;
  List<Task> _tasks = [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final user = _authService.getCurrentUser();
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    setState(() {
      _userId = user.id;
    });

    _syncService = SyncService(
      dbHelper: _dbHelper,
      supabaseHelper: SupabaseHelper(),
      userId: user.id,
    );
    
    await _loadTasks();
  }

  Future<void> _loadTasks() async {
    if (_userId == null) return;
    final tasks = await _dbHelper.getAllTasks(_userId!);
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask() async {
    if (_controller.text.isEmpty || _userId == null) return;

    final task = Task(
      name: _controller.text,
      userId: _userId!,
    );
    
    await _dbHelper.insertTask(task);
    await _syncService.syncUnsynced();
    _controller.clear();
    await _loadTasks();
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _deleteTask(Task task) async {
    await _dbHelper.deleteTask(task.id!);
    if (task.supabaseId != null) {
      await SupabaseHelper().deleteTask(task.supabaseId!);
    }
    await _loadTasks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              await _syncService.syncUnsynced();
              await _loadTasks();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      // Rest of the UI remains the same
       body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a new task',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(task.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        task.isSynced ? Icons.cloud_done : Icons.cloud_upload,
                        color: task.isSynced ? Colors.green : Colors.grey,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTask(task),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}
