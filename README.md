# Clean Architecture Flutter Todo App

Une application Todo développée avec Flutter en suivant les principes de Clean Architecture.

## Architecture

Cette application est structurée selon les principes de Clean Architecture avec une séparation claire entre:

- **Présentation**: UI et gestion d'état avec Bloc et Cubit
- **Domaine**: Logique métier et entités
- **Données**: Sources de données et repositories

## Fonctionnalités

- Gestion de tâches (création, modification, suppression)
- Architecture scalable et testable
- Séparation des préoccupations
- Gestion d'état réactive
- Surveillance du cycle de vie de l'application (WidgetsBindingObserver)
- Surveillance de la connectivité en temps réel
- Intercepteur de requêtes HTTP avec affichage de logs détaillés

## Technologies

- Flutter
- Bloc/Cubit pour la gestion d'état
- Équivalent du SOLID en Dart
- Injection de dépendances

## Overview

Both Bloc and Cubit are part of the [flutter_bloc](https://pub.dev/packages/flutter_bloc) package and provide reactive state management solutions for Flutter applications.

### Key Differences

| Feature | Cubit | Bloc |
|---------|-------|------|
| Complexity | Simpler, less boilerplate | More structured, more boilerplate |
| State Changes | Via direct method calls | Via events |
| Event Traceability | Less traceable | Well-defined event flow |
| Use Case | Simple state transitions | Complex workflows |
| Learning Curve | Easier for beginners | Steeper learning curve |

## Implementation Details

### Shared Components

Both implementations share:
- A common `Todo` model
- Similar UI components
- State representation

### Cubit Implementation

Cubit uses a more direct approach:

```dart
class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoState());

  void loadTodos() async {
    emit(state.copyWith(status: TodoStatus.loading));
    
    // Logic...
    
    emit(state.copyWith(
      todos: todos,
      status: TodoStatus.loaded,
    ));
  }

  void addTodo(String title) {
    // Logic...
    emit(state.copyWith(todos: updatedTodos));
  }
}
```

Using Cubit in UI:

```dart
// Calling methods directly
context.read<TodoCubit>().addTodo('New todo');

// Listening to state
BlocBuilder<TodoCubit, TodoState>(
  builder: (context, state) {
    // Build UI based on state
  }
)
```

### Bloc Implementation

Bloc follows an event-driven approach:

```dart
// Define events
abstract class TodoEvent {}
class AddTodoEvent extends TodoEvent {
  final String title;
  const AddTodoEvent(this.title);
}

// Bloc implementation
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<AddTodoEvent>(_onAddTodo);
  }

  void _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) {
    // Logic...
    emit(state.copyWith(todos: updatedTodos));
  }
}
```

Using Bloc in UI:

```dart
// Dispatching events
context.read<TodoBloc>().add(AddTodoEvent('New todo'));

// Listening to state (same as Cubit)
BlocBuilder<TodoBloc, TodoState>(
  builder: (context, state) {
    // Build UI based on state
  }
)
```

## App Lifecycle Monitoring

The application implements the `WidgetsBindingObserver` to monitor the app's lifecycle states:

- **AppLifecycleState.resumed**: App is visible and responding to user input
- **AppLifecycleState.inactive**: App is not currently responding to user input
- **AppLifecycleState.paused**: App is not visible to the user
- **AppLifecycleState.detached**: App is in a suspended state

This allows the app to:
- Pause/resume network operations when the app enters/exits the background
- Save critical data when the app is about to be terminated
- Refresh data when the app returns to the foreground

## Connectivity Monitoring

The app continuously monitors network connectivity status using the connectivity package:

- Detects when the device connects to or disconnects from the internet
- Adapts UI based on current connectivity status
- Automatically switches between remote and local data sources based on connectivity
- Queues operations when offline for later execution when connection is restored

## Request Interceptor

A custom HTTP request interceptor is implemented to enhance debugging and monitoring:

- Detailed logging of request/response lifecycle with color-coded console output
- Request timing and performance metrics
- Automatic retry mechanism for failed requests
- Request headers and body visualization
- Response status code highlighting and error handling
- Support for mock responses during development

Example debug output:
```
→ REQUEST GET https://api.example.com/todos
→ Headers: {Authorization: Bearer xyz123, Content-Type: application/json}
← RESPONSE [200] (324ms) 
← Body: [{"id": 1, "title": "Complete task", "completed": false}, ...]
```

## When to Use Each

### Use Cubit when:
- Your feature has simple state transitions
- You want less boilerplate code
- The feature doesn't require complex event handling
- You're new to state management in Flutter

### Use Bloc when:
- You need a clear history of all events in the app
- Your feature has complex state transitions
- You want better traceability for debugging
- You have multiple events that lead to the same state change
- You need to implement advanced patterns like debouncing

## Running the App

1. Clone this repository
2. Run `flutter pub get`
3. Run `flutter run`

The app allows you to switch between Cubit and Bloc implementations to compare both approaches with the same UI and functionality.

## Learning Resources

- [Flutter Bloc Documentation](https://bloclibrary.dev/)
- [Cubit vs Bloc](https://bloclibrary.dev/#/coreconcepts?id=cubit)
- [Bloc Architecture Pattern](https://bloclibrary.dev/#/architecture)

## Sealed Classes Implementation

This project also demonstrates the use of Dart's sealed classes for improved type safety and pattern matching in state management.

### Benefits of Sealed Classes

- **Exhaustive Pattern Matching**: The compiler ensures all possible state types are handled
- **Type Safety**: Strong typing guarantees for each state variation
- **Clear State Transitions**: Each state is represented by a distinct class
- **Better Code Organization**: Clearer separation between different states
- **Self-Documenting Code**: States with different properties are explicit

### Sealed Events Example

```dart
sealed class TodoEvent extends Equatable {
  const TodoEvent();
}

final class LoadTodosEvent extends TodoEvent {
  const LoadTodosEvent();
}

final class AddTodoEvent extends TodoEvent {
  final String title;
  const AddTodoEvent(this.title);
}
```

### Sealed States Example

```dart
sealed class TodoState extends Equatable {
  const TodoState();
}

final class TodoInitialState extends TodoState {
  const TodoInitialState();
}

final class TodoLoadingState extends TodoState {
  const TodoLoadingState();
}

final class TodoLoadedState extends TodoState {
  final List<Todo> todos;
  const TodoLoadedState({required this.todos});
}
```

### Using Pattern Matching in UI

```dart
BlocBuilder<TodoBloc, TodoState>(
  builder: (context, state) {
    return switch (state) {
      TodoInitialState() => const Center(child: Text('Initializing...')),
      TodoLoadingState() => const Center(child: CircularProgressIndicator()),
      TodoErrorState(errorMessage: final message) => Center(child: Text('Error: $message')),
      TodoLoadedState(todos: final todos) => _buildTodoList(todos),
    };
  },
)
```


## License & Contact

**Elarbi Chraiet**
- Email: elarbi.chraiet@gmail.com
- LinkedIn: [Elarbi Chraiet](https://www.linkedin.com/in/chraiet-elarbi-606b92138/)
- Mobile (WhatsApp): +33 7 66 06 31 26

For more information about my Flutter expertise, check out my [Generic Requester](https://github.com/Jewelch/generic_requester) project.

## 6. Developer Profile

### Introduction
Senior Flutter and Android Developer (FRANCE) 
9 years of experience | 20+ applications created 

### Technical Expertise
Passionate and results-driven with a strong track record of creating high-quality applications. Expert in:
- Generic programming
- Clean Architecture
- State Management Patterns (BLoC, Riverpod, Provider, Getx, Mobx, Modular)
- Jetpack compose and XML Layout, Dagger 2, Hilt, Couroutines, MVVM, Koin, Retrofit  (Android)
- Automation and testing (Unit, UI, Integration, E2E)
- Performance optimization
- Code maintainability
- Complex system integration

### Notable Flutter Applications
* My Swiss Keeper (Swisse) - [App Store](https://apps.apple.com/fr/app/my-swiss-keeper/id1617620449)
* IRP AUTO Santé (FRANCE) (+100K users) - [App Store](https://apps.apple.com/fr/app/irp-auto-sant%C3%A9/id948623366?l=en) | 
* TLFnet (+2K users) - [Play Store](https://play.google.com/store/apps/details?id=com.tlfnet)

### Notable Android Applications
* Halal App (KSA) - [App Store](https://apps.apple.com/us/app/halal-app-%D8%AD%D9%84%D8%A7%D9%84/id1570293278)

### Leadership and Expertise
In addition to my technical expertise, I bring strong leadership and teamwork capabilities, having held key positions in several organizations:
- GRDF (FRANCE) - Senior Android developer
- Be-ys Software (France) - Flutter Tech Lead
- WiMobi (Tunisia) - Android Tech Lead
