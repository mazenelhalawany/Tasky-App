import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/helper/sharedpreferences.dart';
import 'package:flutter_application_api_bloc/features/add_task/cubit/tasks_state.dart';
import 'package:flutter_application_api_bloc/features/add_task/data/model/task_model.dart';
import 'package:flutter_application_api_bloc/features/add_task/data/repository/tasks_repository_implement.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksCubit extends Cubit<TasksState> {
  final TasksRepositoryImplement repository;
  TasksCubit({required this.repository}) : super(TasksInitial());
  static TasksCubit get(context) => BlocProvider.of(context);
  DateTime? selectedDateTime; // ⬅️ هنخزن فيها التاريخ اللي المستخدم اختاره
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedGroup;
  StreamSubscription? _tasksSubscription;

  void searchTasks(String userId, String query) async {
    emit(SearchTasksLoadingState());
    try {
      // استدعاء البحث من الـ repository
      final allTasks = await repository.getTasks(userId);

      // فلترة النتائج محليًا (لأن Firestore مفيهوش contains)
      final filteredTasks = allTasks.where((task) {
        final title = task.title.toLowerCase();
        final searchQuery = query.toLowerCase();
        return title.contains(searchQuery);
      }).toList();

      emit(SearchTasksSuccessState(filteredTasks));
    } catch (e) {
      emit(SearchTasksErrorState(e.toString()));
    }
  }

  Future<void> deleteTask(String userId, String taskId) async {
    emit(DeleteTaskLoadingState());
    try {
      await repository.deleteTask(userId, taskId);
      emit(DeleteTaskSuccessState());
      await getTasks(userId); // ✅ نحدث الليست بعد الحذف
    } catch (e) {
      emit(DeleteTaskErrorState(e.toString()));
    }
  }

  Future<void> pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        // ندمج التاريخ والوقت في DateTime واحد
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        selectedDateTime = dateTime;
        CacheHelper.saveData(
            key: "selectedDateTime", value: dateTime.toIso8601String());
        emit(TaskDatePickedState(dateTime));
      }
    }
  }

  void selectGroup(String? value) {
    selectedGroup = value;
    emit(TaskGroupSelectedState(value));
  }

  Future<void> addTask(String userId, context) async {
    emit(AddTaskLoadingState());
    try {
      // نستخدم repository.addTask بدون taskid
      final task = TaskModel(
        taskid: '', // مؤقت، Firestore هيضيف ID بعد الإضافة
        group: selectedGroup!,
        title: titleController.text,
        description: descriptionController.text,
        deadLine: selectedDateTime!,
        id: userId,
      );

      // إضافة المهمة، repository هيرجع الـ task مع الـ taskid الحقيقي من Firestore
      await repository.addTask(userId, task, context);

      emit(AddTaskSuccessState());
      await getTasks(userId);
    } catch (e) {
      emit(AddTaskErrorState(e.toString()));
    }
  }

  Future<void> getTasks(String userId) async {
    emit(GetTasksLoadingState());
    try {
      final tasks = await repository.getTasks(userId);
      emit(GetTasksSuccessState(tasks));
    } catch (e) {
      emit(GetTasksErrorState(e.toString()));
    }
  }

  void listenToTasks(String userId) {
    _tasksSubscription?.cancel(); // لو فيه استماع قديم
    _tasksSubscription = repository.listenToTasks(userId).listen((tasks) {
      emit(GetTasksSuccessState(tasks));
    });
  }

  void checkTaskStatus(TaskModel task) {
    final status = repository.getTaskStatus(task);
    emit(TaskStatusCalculatedState(status));
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }

  Future<void> editTask(String userId, TaskModel task) async {
    emit(EditTaskLoadingState());
    try {
      await repository.updateTask(userId, task); // تحديث كل الحقول
      emit(EditTaskSuccessState());
      await getTasks(userId); // إعادة تحميل المهام بعد التعديل
    } catch (e) {
      emit(EditTaskErrorState(e.toString()));
    }
  }

  Future<void> filterTasks({
    required String userId,
    String? category,
    String? status,
  }) async {
    emit(GetTasksLoadingState()); // عشان يظهر مؤشر تحميل بسيط أثناء الفلترة
    try {
      final tasks = await repository.filterTasks(
        userId: userId,
        category: category,
        status: status,
      );
      emit(TasksFiltered(tasks));
    } catch (e) {
      emit(GetTasksErrorState(e.toString()));
    }
  }
}
