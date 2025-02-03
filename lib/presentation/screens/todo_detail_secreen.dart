import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/presentation/bloc/todolist_list/todo_list_bloc.dart';

class TodoDetailScreen extends StatefulWidget {
  final Todo? todo;

  const TodoDetailScreen({Key? key, this.todo}) : super(key: key);

  @override
  _TodoDetailScreenState createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text.trim();
            final description = _descriptionController.text.trim();
            if (title.isNotEmpty && description.isNotEmpty) {
              final todo = Todo(
                todoId: widget.todo?.todoId,
                title: title,
                description: description,
                isCompleted: widget.todo?.isCompleted ?? false,
                createdAt: widget.todo?.createdAt ?? DateTime.now(),
              );
              if (widget.todo == null) {
                context.read<TodoListBloc>().add(AddTodo(todo));
              } else {
                context.read<TodoListBloc>().add(UpdateTodo(todo));
              }
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
