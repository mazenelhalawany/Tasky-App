import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String title;
  final String description;
  final bool isDone;
  final DateTime deadLine;
  final String group;
  String taskid;

  TaskModel(
      {this.id,
      required this.taskid,
      required this.title,
      required this.description,
      this.isDone = false,
      required this.deadLine,
      required this.group});

  TaskModel copyWith({
    String? id,
    String? taskid,
    String? title,
    String? description,
    String? group,
    DateTime? deadLine,
    bool? isDone,
  }) {
    return TaskModel(
      id: id ?? this.id,
      taskid: taskid ?? this.taskid,
      title: title ?? this.title,
      description: description ?? this.description,
      group: group ?? this.group,
      deadLine: deadLine ?? this.deadLine,
      isDone: isDone ?? this.isDone,
    );
  }

  // تحويل إلى Map عشان نحفظه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'taskid': taskid,
      'group': group,
      'userid': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'deadLine': deadLine,
    };
  }

  // تحويل من Map إلى TaskModel
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskid: map['taskid'],
      group: map['group'],
      id: map['userid'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: map['isDone'] ?? false,
      deadLine: (map['deadLine'] as Timestamp).toDate(),
    );
  }
}
