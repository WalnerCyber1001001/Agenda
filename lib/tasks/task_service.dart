import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  static const String _tasksKey = 'tasks';

  /// Salva a lista de tarefas no SharedPreferences
  static Future<void> saveTasks(List<String> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_tasksKey, tasks);
  }

  /// Carrega a lista de tarefas do SharedPreferences
  static Future<List<String>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_tasksKey) ?? [];
  }
}
