import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/data/repositories/todo_repository.dart';

// Events
abstract class TodoListEvent extends Equatable {
  const TodoListEvent();
}

class LoadTodos extends TodoListEvent {
  @override
  List<Object> get props => [];
}

class AddTodo extends TodoListEvent {
  final Todo todo;

  const AddTodo(this.todo);

  @override
  List<Object> get props => [todo];
}

class UpdateTodo extends TodoListEvent {
  final Todo todo;

  const UpdateTodo(this.todo);

  @override
  List<Object> get props => [todo];
}

class DeleteTodo extends TodoListEvent {
  final String todoId;

  const DeleteTodo(this.todoId);

  @override
  List<Object> get props => [todoId];
}

// States
abstract class TodoListState extends Equatable {
  const TodoListState();

  @override
  List<Object> get props => [];
}

class TodoListLoading extends TodoListState {}

class TodoListLoaded extends TodoListState {
  final List<Todo> todos;

  const TodoListLoaded(this.todos);

  @override
  List<Object> get props => [todos];
}

class TodoListError extends TodoListState {
  final String message;

  const TodoListError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final TodoRepository _repository = TodoRepository();

  TodoListBloc() : super(TodoListLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoListState> emit) async {
  try {
    emit(TodoListLoading());
    await for (var todos in _repository.getTodos()) {
      emit(TodoListLoaded(todos)); // Ensure state is updated
    }
  } catch (e) {
    emit(TodoListError(e.toString()));
  }
}


  Future<void> _onAddTodo(AddTodo event, Emitter<TodoListState> emit) async {
    try {
      await _repository.addTodo(event.todo);
    } catch (e) {
      emit(TodoListError(e.toString()));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoListState> emit) async {
    try {
      await _repository.updateTodo(event.todo);
    } catch (e) {
      emit(TodoListError(e.toString()));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoListState> emit) async {
    try {
      await _repository.deleteTodo(event.todoId);
    } catch (e) {
      emit(TodoListError(e.toString()));
    }
  }
}