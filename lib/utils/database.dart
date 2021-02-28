import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uitodo/models/todo_model.dart';

class DatabaseHelper {
  // DBProvider._();

  // static final DBProvider db = DBProvider._();
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  Database _database;

  final String tableTodo = "todo";
  final String columnId = "id";
  final String todoDate = "created_at";

  final String tableTodoDetails = "todo_details";
  final String todoId = "todo_id";
  final String todoDetailsDoing = "doing";
  final String isDone = "is_done";

  DatabaseHelper.internal();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TodoDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $tableTodo("
          "$columnId INTEGER PRIMARY KEY,"
          "$todoDate DATETIME"
          ");");

      await db.execute("CREATE TABLE $tableTodoDetails("
          "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$todoDetailsDoing VARCHAR(255),"
          "$isDone INTEGER,"
          "$todoId INTEGER"
          ");");
    });
  }

  Future<List<TodoModel>> readTodo() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT * FROM $tableTodo ORDER BY $columnId DESC");
    getDetails(Map<String, dynamic> val)async{
      final List<Map<String, dynamic>> todoDetails = await db.rawQuery(
          "SELECT * FROM $tableTodoDetails WHERE $todoId = ${val['$columnId']}");

      TodoModel todoModel = TodoModel();
      todoModel.id = val['id'];
      todoModel.createdAt = val['created_at'];
      todoModel.listTodo =
          todoDetails.map((val) => TodoDetails.fromJson(val)).toList();

      // listTodo.add(todoModel);
      return todoModel;
      
    }

    List<TodoModel> listTodo = await Future.wait(result.map((val) async => await getDetails(val)).toList());

    

    return listTodo;
  }

  Future<Null> createTodo(TodoModel todoModel) async {
    final db = await database;

    var table = await db
        .rawQuery("SELECT MAX($columnId)+1 as $columnId FROM $tableTodo");
    int id = table.first['$columnId'] != null ? table.first['$columnId'] : 1;

    Batch batch = db.batch();

    batch.insert(
        "$tableTodo", {'$columnId': id, '$todoDate': todoModel.createdAt});

    todoModel.listTodo.forEach((val) async {
      int valIsDone = val.isDone ? 1 : 0;
      batch.insert("$tableTodoDetails", {
        '$todoDetailsDoing': val.doing,
        '$isDone': valIsDone,
        '$todoId': id
      });
    });

    await batch.commit();
    return null;
  }

  Future<Null> updateTodo(TodoDetails todoDetails) async {
    final db = await database;
    // var res = await db.update("todo", todoModel);
    return await db.update("$tableTodo", todoDetails.toJson(),
        where: "$columnId = ?", whereArgs: [todoDetails.id]);
  }

  Future<Null> deleteTodo(TodoDetails todoDetails) async {
    final db = await database;

    await db.delete("$tableTodoDetails",
        where: "$columnId = ?", whereArgs: [todoDetails.id]);

    var detailList = await db.rawQuery(
        "SELECT * FROM $tableTodoDetails WHERE $todoId = ${todoDetails.todoId}");
    // print(detailList);
    if (detailList.length < 1) {
      await db.delete("$tableTodo",
          where: "$columnId = ?", whereArgs: [todoDetails.todoId]);
    }

    return null;
  }
}
