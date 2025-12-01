import 'package:flutter_application_api_bloc/core/services/firebase_firestore_service.dart';
import 'package:flutter_application_api_bloc/features/add_task/data/model/task_model.dart';
import 'package:flutter_application_api_bloc/features/add_task/data/repository/tasks_repository.dart';

class TasksRepositoryImplement implements TasksRepository {
  final FirebaseHomeService firebaseHomeService;

  TasksRepositoryImplement( {required this.firebaseHomeService});

  @override
  
  Future<void> addTask(String userId, TaskModel task, context) async {
    await firebaseHomeService.addTask(userId, task, context);
 
  }

  @override
  Future<List<TaskModel>> getTasks(String userId) async {
    return await firebaseHomeService.getTasks(userId);
    
  }

  @override
  Stream<List<TaskModel>> listenToTasks(String userId) {
    return firebaseHomeService.listenToTasks(userId);
  }

  @override
  Stream<List<Map<String, dynamic>>> searchTasks(String userId, String query) {
    return firebaseHomeService.searchTasks(userId, query);
  }

  @override
  String getTaskStatus(TaskModel task) {
    return firebaseHomeService.getTaskStatus(task);
  }

  @override
  Future<void> updateTask(String userId, TaskModel taskId) {
    return firebaseHomeService.updateTask(
      userId,
      taskId,
    );
  }

  @override
  Future<void> deleteTask(String userId, String taskId) {
    return firebaseHomeService.deleteTask(userId, taskId);
  }

  @override
  Future<List<TaskModel>> filterTasks({
    required String userId,
    String? category,
    String? status,
  }) {
    return firebaseHomeService.filterTasks(
      userId: userId,
      category: category,
      status: status,
    );
  }
}
