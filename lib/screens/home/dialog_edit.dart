import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uitodo/blocs/todo/todo_bloc.dart';
import 'package:uitodo/models/todo_model.dart';
import 'package:uitodo/utils/constants.dart';

class DialogEdit extends StatefulWidget {
  final TodoDetails todoDetails;

  DialogEdit({Key key, @required this.todoDetails}) : super(key: key);

  @override
  _DialogEditState createState() => _DialogEditState();
}

class _DialogEditState extends State<DialogEdit> {
  TodoDetails todoDetails;

  @override
  void initState() { 
    super.initState();
    todoDetails = widget.todoDetails;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Todo"),
      content: Container(
        margin: EdgeInsets.only(bottom: 15),
        // decoration: BoxDecoration(
        //   color: bgFormInputColor,
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(20),
        //   ),
        // ),
        child: TextFormField(
          // decoration: InputDecoration(
          //   // hintText: "What are you gonna do?",
          //   labelStyle: TextStyle(color: textFormInputColor),
          //   border: InputBorder.none,
          //   contentPadding: EdgeInsets.symmetric(horizontal: 10),
          // ),
          initialValue: todoDetails.doing,
          onChanged: (val) {
            todoDetails.doing = val;
            // print(todo.toJson());
            // print(todoDetails.doing);
          },
        ),
      ),
      actions: [
        FlatButton(
          textColor: textSecondaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
        ),
        FlatButton(
          onPressed: () {
            BlocProvider.of<TodoBloc>(context)
                .add(TodoUpdateEvent(todoDetails: todoDetails));
            Navigator.pop(context);
          },
          textColor: Colors.blueAccent,
          child: Text('Update'),
        ),
      ],
    );
  }
}
