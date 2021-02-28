import 'package:flutter/cupertino.dart';
import 'package:uitodo/models/todo_model.dart';
import 'package:uitodo/utils/database.dart';

abstract class TodoRepository {
  Future<List<TodoModel>> fetchTodo();
  Future<List<TodoModel>> createTodo({@required TodoModel todoModel});
  Future<List<TodoModel>> updateTodo({@required TodoDetails todoDetails});
  Future<List<TodoModel>> deleteTodo({@required TodoDetails todoDetails});
}

class TodoRepositoryImp implements TodoRepository {
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Future<List<TodoModel>> fetchTodo() async {
    var listTodo = await dbHelper.readTodo();
    return listTodo;
  }

  @override
  Future<List<TodoModel>> createTodo({TodoModel todoModel}) async {
    await dbHelper.createTodo(todoModel);

    return await dbHelper.readTodo();
  }

  @override
  Future<List<TodoModel>> updateTodo({@required TodoDetails todoDetails}) async{

    await dbHelper.updateTodo(todoDetails);

    return await dbHelper.readTodo();
  }

  @override
  Future<List<TodoModel>> deleteTodo({TodoDetails todoDetails}) async {
    await dbHelper.deleteTodo(todoDetails);

    return await dbHelper.readTodo();
  }
}
