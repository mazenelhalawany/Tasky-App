import 'package:flutter_application_api_bloc/features/add_task/data/model/task_model.dart';

abstract class TasksState {}

class TasksInitial extends TasksState {}

/// ----------------------
/// 🔹 إضافة تاسك جديدة
/// ----------------------
class AddTaskLoadingState extends TasksState {}

class AddTaskSuccessState extends TasksState {}

class AddTaskErrorState extends TasksState {
  final String message;
  AddTaskErrorState(this.message);
}

/// ----------------------
/// 🔹 جلب المهام (Tasks)
/// ----------------------
class GetTasksLoadingState extends TasksState {}

class GetTasksSuccessState extends TasksState {
  final List<TaskModel> tasks;
  GetTasksSuccessState(this.tasks);
}

class GetTasksErrorState extends TasksState {
  final String getmessage;
  GetTasksErrorState(this.getmessage);
}

class TaskDatePickedState extends TasksState {
  final DateTime date;
  TaskDatePickedState(this.date);
}

class TaskGroupSelectedState extends TasksState {
  final String? group;
  TaskGroupSelectedState(this.group);
}

class SearchTasksLoadingState extends TasksState {}

class SearchTasksSuccessState extends TasksState {
  final List<TaskModel> tasks;
  SearchTasksSuccessState(this.tasks);
}

class SearchTasksErrorState extends TasksState {
  final String searchmessage;
  SearchTasksErrorState(this.searchmessage);
}

class TasksFiltered extends TasksState {
  final List<TaskModel> filteredTasks;
  TasksFiltered(this.filteredTasks);
}

class TaskStatusCalculatedState extends TasksState {
  final String status;
  TaskStatusCalculatedState(this.status);
}

class EditTaskLoadingState extends TasksState {}

class EditTaskSuccessState extends TasksState {}

class EditTaskErrorState extends TasksState {
  final String editmessage;
  EditTaskErrorState(this.editmessage);
}

class DeleteTaskLoadingState extends TasksState {}

class DeleteTaskSuccessState extends TasksState {}

class DeleteTaskErrorState extends TasksState {
  final String message;
  DeleteTaskErrorState(this.message);
}
