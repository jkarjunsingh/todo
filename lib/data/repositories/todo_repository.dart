import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/domain/entities/todo.dart';


class TodoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Stream<List<Todo>> getTodos() {
  return _firestore.collection('todos').orderBy('createdAt', descending: true).snapshots().map(
    (snapshot) {
      print("Fetching todos... Count: ${snapshot.docs.length}"); // Debugging
      return snapshot.docs.map((doc) => Todo.fromFirestore(doc)).toList();
    },
  );
}

  Future<void> addTodo(Todo todo) async {
    await _firestore.collection('todos').add(todo.toFirestore());
  }

  Future<void> updateTodo(Todo todo) async {
    await _firestore
        .collection('todos')
        .doc(todo.todoId)
        .update(todo.toFirestore());
  }

  Future<void> deleteTodo(String todoId) async {
    await _firestore.collection('todos').doc(todoId).delete();
  }
}