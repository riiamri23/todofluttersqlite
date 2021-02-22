part of 'todo_bloc.dart';

@immutable
abstract class TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState{
  final List<TodoModel> listTodo;

  TodoLoaded({@required this.listTodo});
}

class TodoFailure extends TodoState{}