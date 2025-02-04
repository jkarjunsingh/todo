import 'package:todo_app/data/models/todo_model.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final TodoModel todo;
  AddTodo(this.todo);
}

class UpdateTodo extends TodoEvent {
  final TodoModel todo;
  UpdateTodo(this.todo);
}

class DeleteTodo extends TodoEvent {
  final String id;
  DeleteTodo(this.id);
}

class SearchTodo extends TodoEvent {
  final String query;
  SearchTodo(this.query);
}
