import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uitodo/blocs/todo/todo_bloc.dart';
import 'package:uitodo/models/todo_model.dart';
import 'package:uitodo/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogFormTodo extends StatefulWidget {
  const DialogFormTodo({
    Key key,
  }) : super(key: key);

  @override
  _DialogFormTodoState createState() => _DialogFormTodoState();
}

class _DialogFormTodoState extends State<DialogFormTodo> {
  List<Widget> doingWidgets = [];
  List<TodoDetails> listTodo = [];

  final format = DateFormat("yyyy-MM-dd HH:mm");

  DateTime dateTime;
  @override
  Widget build(BuildContext context) {
    if (doingWidgets.length < 1) {
      listTodo.add(TodoDetails(doing: '', isDone: false));
      doingWidgets.add(doingInput(listTodo[listTodo.length - 1]));
    }
    return AlertDialog(
      title: Text(
        'Add List',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                ListView.builder(
                  itemCount: doingWidgets.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return doingWidgets[i];
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      listTodo.add(TodoDetails(doing: '', isDone: false));
                      doingWidgets
                          .add(doingInput(listTodo[listTodo.length - 1]));
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    decoration: BoxDecoration(
                      color: bgTodoPlusColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: textDarkerColor,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                DateTimeField(
                  decoration: InputDecoration(
                      hintText: "Date",
                      suffixIcon: Icon(Icons.keyboard_arrow_down_rounded)),
                  format: format,
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                  onChanged: (val) {
                    // print(val);
                    dateTime = val;
                  },
                ),
              ],
            ),
          ),
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
            if (dateTime != null && listTodo[0].doing.isNotEmpty) {
              BlocProvider.of<TodoBloc>(context).add(
                TodoAddEvent(
                  todoModel: TodoModel(
                    id: 1,
                    createdAt: dateTime.toString(),
                    listTodo: listTodo,
                  ),
                ),
              );
              Navigator.pop(context);
              return;
            }
            
            Fluttertoast.showToast(
                msg: "Please do something and don't forget to fill the date",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            // BlocProvider.of<TodoBloc>(context).add(TodoReadEvent());
          },
          textColor: Colors.black,
          child: Text('Add List'),
        ),
      ],
    );
  }

  Container doingInput(TodoDetails todo) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: bgFormInputColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "What are you gonna do?",
          labelStyle: TextStyle(color: textFormInputColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        onChanged: (val) {
          todo.doing = val;
          // print(todo.toJson());
        },
      ),
    );
  }
}

// class TodoDate extends StatelessWidget {
//   final format = DateFormat("yyyy-MM-dd HH:mm");

//   DateTime dateTime;

//   TodoDate({@required this.dateTime});
//   @override
//   Widget build(BuildContext context) {
//     return DateTimeField(
//       decoration: InputDecoration(
//           hintText: "Date",
//           suffixIcon: Icon(Icons.keyboard_arrow_down_rounded)),
//       format: format,
//       onShowPicker: (context, currentValue) async {
//         final date = await showDatePicker(
//             context: context,
//             firstDate: DateTime(1900),
//             initialDate: currentValue ?? DateTime.now(),
//             lastDate: DateTime(2100));
//         if (date != null) {
//           final time = await showTimePicker(
//             context: context,
//             initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
//           );
//           return DateTimeField.combine(date, time);
//         } else {
//           return currentValue;
//         }
//       },
//       onChanged: (val) {
//         // print(val);
//         dateTime = val;
//       },
//     );
//   }
// }
