part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class TodoAddEvent extends TodoEvent{
  final TodoModel todoModel;

  TodoAddEvent({@required this.todoModel});
}
class TodoReadEvent extends TodoEvent{
  
}

class TodoDeleteEvent extends TodoEvent{
  final TodoDetails todoDetails;

  TodoDeleteEvent({@required this.todoDetails});
}