part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class TodoReadEvent extends TodoEvent{
  
}
class TodoAddEvent extends TodoEvent{
  final TodoModel todoModel;

  TodoAddEvent({@required this.todoModel});
}

class TodoUpdateEvent extends TodoEvent{
  final TodoDetails todoDetails;

  TodoUpdateEvent({@required this.todoDetails});
}

class TodoDeleteEvent extends TodoEvent{
  final TodoDetails todoDetails;

  TodoDeleteEvent({@required this.todoDetails});
}