import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/bloc/theme/theme_state.dart';
import 'package:todo_app/presentation/bloc/todo/todo_event.dart';
import 'package:todo_app/presentation/screens/todo_list_screen.dart';
import 'presentation/bloc/todo/todo_bloc.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'data/repositories/todo_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoBloc(TodoRepository())..add(LoadTodos())),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state is LightTheme ? ThemeData.light() : ThemeData.dark(),
            home: TodoListScreen(),
          );
        },
      ),
    );
  }
}
