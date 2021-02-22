import 'package:flutter/cupertino.dart';

class TodoModel {
  int id;
  String createdAt;
  bool isShow = true;
  List<TodoDetails> listTodo = [];

  TodoModel({ this.id, this.createdAt, this.listTodo});

  TodoModel.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
    createdAt = json['created_at'] ?? '';
    isShow = json['is_show'];

    if(json['todo_details'] != null){
      listTodo = List<TodoDetails>();
      json['todo_details'].forEach((v){
        listTodo.add(TodoDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(){
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['created_at'] = createdAt;
    map['is_show'] = isShow;
    if(this.listTodo != null){
      map['todo_details'] = this.listTodo.map((v)=>v.toJson()).toList();
    }

    return map;
  }


}

class TodoDetails {
  int id;
  String doing;
  bool isDone;

  TodoDetails({ this.id, this.doing, this.isDone});

  TodoDetails.fromJson(Map<String, dynamic> json){
    id = json['id'];
    doing = json['doing'];
    isDone = json['is_done'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id'] = this.id;
    data['doing'] = this.doing;
    data['is_done'] = this.isDone ? 1 : 0;

    return data;
  }
}