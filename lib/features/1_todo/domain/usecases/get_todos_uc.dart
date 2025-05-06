import 'package:generic_requester/generic_requester.dart' show Either;

import '../../../../core/error/failures.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetTodosUC {
  final TodoRepository repository;

  GetTodosUC(this.repository);

  Future<Either<Failure, List<TodoEntity>>> execute() async {
    return await repository.getTodos();
  }
}
