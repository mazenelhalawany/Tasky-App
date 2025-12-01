import 'package:flutter_application_api_bloc/features/add_task/data/model/task_model.dart';

abstract class TasksRepository {
  Future<void> addTask(String userId, TaskModel task, context);
  Future<List<TaskModel>> getTasks(String userId);
  Stream<List<TaskModel>> listenToTasks(String userId); // ✅ هنا}
  Stream<List<Map<String, dynamic>>> searchTasks(String userId, String query);
  String getTaskStatus(TaskModel task);
  Future<void> updateTask(
    String userId,
    TaskModel taskId,
  );
  Future<void> deleteTask(String userId, String taskId);

  Future<List<TaskModel>> filterTasks({
    required String userId,
    String? category,
    String? status,
  });
}
