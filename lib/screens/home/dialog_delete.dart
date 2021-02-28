import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uitodo/blocs/todo/todo_bloc.dart';
import 'package:uitodo/models/todo_model.dart';
import 'package:uitodo/utils/constants.dart';

class DialogDelete extends StatefulWidget {

  final TodoDetails todoDetails;
  DialogDelete({Key key, @required this.todoDetails}) : super(key: key);

  @override
  _DialogDeleteState createState() => _DialogDeleteState();
}

class _DialogDeleteState extends State<DialogDelete> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Todo"),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Text('Are you sure delete this?'),
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
                .add(TodoDeleteEvent(todoDetails: widget.todoDetails));
            // BlocProvider.of<TodoBloc>(context).add(TodoReadEvent());
            Navigator.pop(context);
          },
          textColor: Colors.red,
          child: Text('Delete'),
        ),
      ],
    );
  }
}
