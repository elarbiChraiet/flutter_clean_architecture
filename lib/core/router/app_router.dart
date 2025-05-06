import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/1_todo/binding/todo_bindings.dart';
import '../../features/1_todo/presentation/bloc/todo_bloc.dart';
import '../../features/1_todo/presentation/screens/todo_screen.dart';
import '../../main.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/todos',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/todos',
      name: 'todos',
      builder:
          (context, state) => BlocProvider<TodoBloc>(
            create: (_) {
              injectTodosBindings();
              return sl<TodoBloc>();
            },
            child: const TodoScreen(),
          ),
    ),
    // GoRoute(path: '/product/:id', name: 'product'),
  ],
);
