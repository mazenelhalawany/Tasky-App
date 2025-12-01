import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_api_bloc/core/models/user_model.dart';
import 'package:flutter_application_api_bloc/features/add_task/data/model/task_model.dart';

class FirebaseHomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 البحث في المهام
  Stream<List<Map<String, dynamic>>> searchTasks(String userId, String query) {
    return _firestore
        .collection('tasks')
        .where('id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .where((doc) => doc['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .map((doc) => doc.data())
          .toList();
    });
  }

  // 🔹 الاستماع للمهام Realtime
  Stream<List<TaskModel>> listenToTasks(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .orderBy('deadLine', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromMap({
                  ...doc.data(),
                  'taskid': doc.id, // ⚡ ID حقيقي من Firestore
                }))
            .toList());
  }

  // 🔹 حفظ بيانات المستخدم
  Future<void> saveUserData(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  // 🔹 إضافة مهمة جديدة (Firestore يولد ID تلقائي)
  Future<void> addTask(String userId, TaskModel task, context) async {
    final taskRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(); // Firestore يولد ID تلقائي
    await taskRef.set(task.toMap());
    // نحدث الـ taskid في الـ model بعد الإضافة
    task.taskid = taskRef.id;

    // final cubit = TasksCubit.get(context);
    // FirebaseNotification notificationService = FirebaseNotification();
    // // if (cubit.selectedDateTime != null) {
    //   await notificationService.scheduleTaskNotification(
    //     title: 'Do Task Now!',
    //     body: 'One hour left and your task will be missing',
    //     taskTime: cubit.selectedDateTime!,
    //   );
    // }
  }

  // 🔹 جلب كل المهام
  Future<List<TaskModel>> getTasks(String userId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .orderBy('deadLine', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => TaskModel.fromMap({
              ...doc.data(),
              'taskid': doc.id, // ⚡ ID حقيقي من Firestore
            }))
        .toList();
  }

  // 🔹 تحديث مهمة موجودة
  Future<void> updateTask(String userId, TaskModel task) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(task.taskid) // استخدام الـ ID من Firestore
        .update(task.toMap());
  }

  // 🔹 جلب بيانات المستخدم
  Future<UserModel> getUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) {
      throw Exception("User not found");
    }
    return UserModel.fromMap(doc.data()!);
  }

  // 🔹 حالة المهمة
  String getTaskStatus(TaskModel task) {
    final now = DateTime.now();
    if (task.isDone) {
      return 'Done';
    } else if (task.deadLine.isBefore(now)) {
      return 'Missed';
    } else {
      return 'In Progress';
    }
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  Future<List<TaskModel>> filterTasks({
    required String userId,
    String? category,
    String? status,
  }) async {
    try {
      Query query =
          _firestore.collection('users').doc(userId).collection('tasks');

      // 🔹 فلترة حسب الفئة
      if (category != null && category.isNotEmpty && category != 'All') {
        query = query.where('group', isEqualTo: category);
      }

      // 🔹 لو الحالة Done
      if (status == 'Done') {
        query = query.where('isDone', isEqualTo: true);
      }

      // 🔹 لو الحالة In Progress أو Missed
      else if (status == 'In Progress' || status == 'Missed') {
        query = query.where('isDone', isEqualTo: false);
      }

      final snapshot = await query.get();
      final allTasks = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TaskModel.fromMap({...data, 'taskid': doc.id});
      }).toList();

      // 🔹 فلترة حسب الحالة في الكود (حسب الوقت)
      if (status == 'Missed') {
        // متأخرة
        return allTasks
            .where((t) => t.deadLine.isBefore(DateTime.now()))
            .toList();
      } else if (status == 'In Progress') {
        // لسه وقتها مجاش
        return allTasks
            .where((t) => t.deadLine.isAfter(DateTime.now()))
            .toList();
      }

      return allTasks;
    } catch (e, st) {
      log('filterTasks error: $e\n$st');
      rethrow;
    }
  }
}
