part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class TodoAddEvent extends TodoEvent{
  final TodoModel todoModel;

  TodoAddEvent({@required this.todoModel});
}
class TodoReadEvent extends TodoEvent{
  
}