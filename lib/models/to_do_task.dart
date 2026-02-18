import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskPriority { low, medium, high }

TaskPriority taskPriorityStringToEnum(String taskPriority) {
  switch (taskPriority) {
    case 'low':
      return TaskPriority.low;
    case 'medium':
      return TaskPriority.medium;
    case 'high':
      return TaskPriority.high;
    default:
      return TaskPriority.low;
  }
}

enum TaskStatus { completed, onProgress, incomplete }

TaskStatus taskStatusStringToEnum(String taskStatus) {
  switch (taskStatus) {
    case 'completed':
      return TaskStatus.completed;
    case 'onProgress':
      return TaskStatus.onProgress;
    case 'incomplete':
      return TaskStatus.incomplete;
    default:
      return TaskStatus.incomplete;
  }
}

class ToDoTask {
  String title;
  String description;
  TaskPriority taskPriority;
  TaskStatus taskStatus;
  DateTime dueDate;
  DateTime timeCreated;
  DateTime lastUpdated;

  ToDoTask({
    required this.title,
    required this.description,
    required this.taskPriority,
    required this.taskStatus,
    required this.dueDate,
    required this.timeCreated,
    required this.lastUpdated,
  });

  factory ToDoTask.fromFirebase(dynamic data) {
    return ToDoTask(
      title: data['title'],
      description: data['description'],
      taskPriority: taskPriorityStringToEnum(data['task_priority']),
      taskStatus: taskStatusStringToEnum(data['task_status']),
      dueDate: (data['due_date'] as Timestamp).toDate(),
      timeCreated: (data['time_created'] as Timestamp).toDate(),
      lastUpdated: (data['last_updated'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toMap(ToDoTask data) {
    return {
      'title': data.title,
      'description': data.description,
      'task_priority': data.taskPriority.name,
      'task_status': data.taskStatus.name,
      'due_date': Timestamp.fromDate(data.dueDate),
      'time_created': Timestamp.fromDate(data.timeCreated),
      'last_updated': Timestamp.fromDate(data.lastUpdated),
    };
  }
}
