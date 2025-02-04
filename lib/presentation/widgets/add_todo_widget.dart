import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/todo/todo_bloc.dart';
import '../bloc/todo/todo_event.dart';
import '../../data/models/todo_model.dart';
import 'package:uuid/uuid.dart';
class AddTodoScreen extends StatefulWidget {
  final TodoModel? todo;
  const AddTodoScreen({Key? key, this.todo}) : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _selectedDate;
  final _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _noteController.text = widget.todo!.note;
      _selectedDate = widget.todo!.dateTime;
    }
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final newTodo = TodoModel(
        id: widget.todo?.id ?? _uuid.v4(),
        title: _titleController.text,
        note: _noteController.text,
        dateTime: _selectedDate ?? DateTime.now(),
      );

      if (widget.todo == null) {
        context.read<TodoBloc>().add(AddTodo(newTodo));
      } else {
        context.read<TodoBloc>().add(UpdateTodo(newTodo));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) return 'Title cannot be empty';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'Note'),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(
                  _selectedDate == null
                      ? 'Pick a date'
                      : DateFormat.yMMMd().format(_selectedDate!),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTodo,
                child: Text('Save Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
