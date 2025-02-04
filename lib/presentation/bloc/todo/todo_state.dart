import 'package:todo_app/data/models/todo_model.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoModel> todos;
  final List<TodoModel> filteredTodos;

  TodoLoaded(this.todos, {List<TodoModel>? filteredTodos})
      : filteredTodos = filteredTodos ?? todos;
      bool get isEmpty => todos.isEmpty;
}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
}
