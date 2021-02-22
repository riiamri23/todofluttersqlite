import 'package:flutter/cupertino.dart';
import 'package:uitodo/models/todo_model.dart';
import 'package:uitodo/utils/database.dart';

abstract class TodoRepository{
  Future<List<TodoModel>> fetchTodo();
  Future<TodoModel> createTodo({@required TodoModel todoModel});
}

class TodoRepositoryImp implements TodoRepository{
  DatabaseHelper dbHelper = DatabaseHelper();


  @override
  Future<List<TodoModel>> fetchTodo() async{
      return await dbHelper.readTodo();
    }
  @override
  Future<TodoModel> createTodo({TodoModel todoModel}) async {
    dbHelper.createTodo(todoModel);

    return null;
  }

}