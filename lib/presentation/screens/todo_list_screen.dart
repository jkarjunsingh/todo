import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/widgets/todo_item.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/presentation/bloc/todolist_list/todo_list_bloc.dart';
import 'package:todo_app/presentation/screens/todo_detail_secreen.dart';
class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTodoDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<TodoListBloc, TodoListState>(
        builder: (context, state) {
          if (state is TodoListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoListError) {
            return Center(child: Text(state.message));
          } else if (state is TodoListLoaded) {
             if (state.todos.isEmpty) {
    return Center(child: Text("No tasks available."));
  }
            final completedTodos = state.todos.where((t) => t.isCompleted).toList();
            final incompleteTodos = state.todos.where((t) => !t.isCompleted).toList();

            return ListView(
              children: [
                _buildSection('Incomplete', incompleteTodos, context),
                _buildSection('Completed', completedTodos, context),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Todo> todos, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$title (${todos.length})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...todos.map((todo) => TodoItem(todo: todo)).toList(),
      ],
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TodoDetailScreen(),
    );
  }
}