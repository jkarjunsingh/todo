import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/widgets/add_todo_widget.dart';
import '../bloc/todo/todo_bloc.dart';
import '../bloc/todo/todo_event.dart';
import '../bloc/todo/todo_state.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';
import '../../data/models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoListScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<TodoBloc>().add(SearchTodo(value));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoaded) {
                  if (state.isEmpty) {
                    return Center(
                      child: Text(
                        "No todos found. Add a new one!",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  final todos = state.filteredTodos;
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Dismissible(
                        key: Key(todo.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          context.read<TodoBloc>().add(DeleteTodo(todo.id));
                        },
                        child: ListTile(
                          title: Text(todo.title),
                          subtitle: Text(todo.note),
                          leading: Checkbox(
                            value: todo.isDone,
                            onChanged: (value) {
                              final updatedTodo = TodoModel(
                                id: todo.id,
                                title: todo.title,
                                note: todo.note,
                                dateTime: todo.dateTime,
                                isDone: value ?? false,
                              );
                              context.read<TodoBloc>().add(UpdateTodo(updatedTodo));
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTodoScreen(todo: todo),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is TodoError) {
                  return Center(child: Text("Error: ${state.message}"));
                }

                return Center(child: CircularProgressIndicator()); // Default loading state
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
