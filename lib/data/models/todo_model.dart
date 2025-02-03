import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String? todoId;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  const Todo({
    this.todoId,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  factory Todo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Todo(
      todoId: doc.id,
      title: data['title'],
      description: data['description'],
      isCompleted: data['isCompleted'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  List<Object?> get props => [todoId, title, description, isCompleted, createdAt];
}