import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/todo_model.dart';
import '../../../data/repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;

  TodoBloc(this._todoRepository) : super(TodoInitial()) {
on<LoadTodos>((event, emit) async {
  try {
    await emit.forEach<List<TodoModel>>(
      _todoRepository.getTodos(),
      onData: (todos) => TodoLoaded(todos),
      onError: (error, stackTrace) => TodoError(error.toString()),
    );
  } catch (e) {
    emit(TodoError(e.toString()));
  }
});


    on<AddTodo>((event, emit) async {
      await _todoRepository.addTodo(event.todo);
    });

    on<UpdateTodo>((event, emit) async {
      await _todoRepository.updateTodo(event.todo);
    });

    on<DeleteTodo>((event, emit) async {
      await _todoRepository.deleteTodo(event.id);
    });

    on<SearchTodo>((event, emit) {
      if (state is TodoLoaded) {
        final allTodos = (state as TodoLoaded).todos;
        final filtered = allTodos
            .where((todo) =>
                todo.title.toLowerCase().contains(event.query.toLowerCase()) ||
                todo.note.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(TodoLoaded(allTodos, filteredTodos: filtered));
      }
    });
  }
}
