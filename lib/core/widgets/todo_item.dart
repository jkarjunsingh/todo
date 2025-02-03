import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/presentation/bloc/todolist_list/todo_list_bloc.dart';
import 'package:todo_app/presentation/screens/todo_detail_secreen.dart';


class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            icon: Icons.delete,
            backgroundColor: Colors.red,
            onPressed: (_) => _deleteTodo(context),
          ),
        ],
      ),
      child: ListTile(
        title: Text(todo.title),
        subtitle: Text(todo.description),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) => _toggleStatus(context),
        ),
        onTap: () => _navigateToDetail(context),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetailScreen(todo: todo),
      ),
    );
  }

  void _toggleStatus(BuildContext context) {
    final updatedTodo = Todo(
      todoId: todo.todoId,
      title: todo.title,
      description: todo.description,
      isCompleted: !todo.isCompleted,
      createdAt: todo.createdAt,
    );
    context.read<TodoListBloc>().add(UpdateTodo(updatedTodo));
  }

  void _deleteTodo(BuildContext context) {
    context.read<TodoListBloc>().add(DeleteTodo(todo.todoId!));
  }
}