import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uitodo/models/todo_model.dart';
import 'package:uitodo/services/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;
  TodoBloc({@required TodoRepository todoRepository})
      : assert(todoRepository != null),
        _todoRepository = todoRepository,
        super(TodoLoading());

  @override
  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
    if (event is TodoAddEvent) {
      yield* mapAddTodoToState(event);
    } else if (event is TodoReadEvent) {
      yield* mapReadTodoToState();
    }else if(event is TodoDeleteEvent){
      yield* mapDeleteTodoToState(event);
    }
  }

  Stream<TodoState> mapAddTodoToState(TodoAddEvent event) async* {
    _todoRepository.createTodo(todoModel: event.todoModel);
  }

  Stream<TodoState> mapReadTodoToState() async* {
    yield TodoLoading();

    try {
      List<TodoModel> listTodo = await _todoRepository.fetchTodo();
      yield TodoLoaded(listTodo: listTodo);
    } catch (_) {
      print(_);
      yield TodoFailure();
    }
  }

  Stream<TodoState> mapDeleteTodoToState(TodoDeleteEvent event) async*{
    _todoRepository.deleteTodo(todoDetails: event.todoDetails);
  }
}
