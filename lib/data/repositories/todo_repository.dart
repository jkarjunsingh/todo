import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class TodoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTodo(TodoModel todo) async {
    await _firestore.collection('todos').doc(todo.id).set(todo.toFirestore());
  }

  Future<void> updateTodo(TodoModel todo) async {
    await _firestore.collection('todos').doc(todo.id).update(todo.toFirestore());
  }

  Future<void> deleteTodo(String id) async {
    await _firestore.collection('todos').doc(id).delete();
  }

  Stream<List<TodoModel>> getTodos() {
    return _firestore.collection('todos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TodoModel.fromFirestore(doc.data())).toList();
    });
  }
}
