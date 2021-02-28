import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uitodo/blocs/todo/todo_bloc.dart';
import 'package:uitodo/models/todo_model.dart';
import 'package:uitodo/screens/home/dialog.dart';
import 'package:uitodo/screens/home/dialog_delete.dart';
import 'package:uitodo/screens/home/dialog_edit.dart';
import 'package:uitodo/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SlidableController slidableController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          height: 120.0,
          color: bgAppBarColor,
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                Text("Todo List",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: textColor,
                    )),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IconButton(
                    //   color: textColor,
                    //   icon: Icon(Icons.check),
                    //   onPressed: () {},
                    // ),
                    IconButton(
                      color: textColor,
                      icon: Icon(Icons.add),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogFormTodo();
                          },
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        // AppBar(
        //   backgroundColor: bgAppBarColor,
        //   automaticallyImplyLeading: false,
        //   title: Text("Todo List"),
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.check),
        //       onPressed: () {},
        //     ),
        //     IconButton(
        //       icon: Icon(Icons.add),
        //       onPressed: () {
        //         showDialog(
        //           context: context,
        //           builder: (BuildContext context) {
        //             return DialogFormTodo();
        //           },
        //         );
        //       },
        //     )
        //   ],
        // ),
      ),
      body: SafeArea(
        child: Container(
          color: bgBodyColor,
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoLoading) {
              } else if (state is TodoLoaded) {
                // print(state.listTodo);
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<TodoBloc>(context).add(TodoReadEvent());
                  },
                  child: ListView.builder(
                    itemCount: state.listTodo.length,
                    itemBuilder: (context, index) {
                      // print(state.listTodo[index].toJson());
                      return todoContainer(state.listTodo[index]);
                    },
                  ),
                );
              } else if (state is TodoFailure) {
                return Container(
                  child: Center(
                    child: Text('Something wrong'),
                  ),
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Container todoContainer(TodoModel todoModel) => Container(
        child: Column(
          children: [
            todoDate(todoModel),
            SizedBox(
              height: 20,
            ),
            todoContents(todoModel.listTodo, todoModel.isShow),
          ],
        ),
      );

  Widget todoDate(TodoModel todoModel) => GestureDetector(
        onTap: () {},
        child: Container(
          child: Row(
            children: [
              Text(
                todoModel.createdAt,
                style: TextStyle(fontSize: 14, color: textColor),
              ),
              IconButton(
                icon: Icon(
                  todoModel.isShow
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: textColor,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    todoModel.isShow = !todoModel.isShow;
                  });
                },
              ),
            ],
          ),
        ),
      );

  Widget todoContents(List<TodoDetails> todoDetails, bool isShow) {
    List<Widget> todoWidgets = [];

    todoDetails.forEach((val) {
      todoWidgets.add(todo(val));
    });
    return Visibility(
      visible: isShow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: todoWidgets,
      ),
    );
  }

  static Widget _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      default:
        return null;
    }
  }

  Widget todo(TodoDetails todoDetails) => Slidable(
        key: Key(todoDetails.id.toString()),
        // onDismissed: (direction) {},
        controller: slidableController,
        actionPane: _getActionPane(1),
        secondaryActions: <Widget>[
          Container(
            height: 70,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    actionButton(
                        icon: Icons.check,
                        color: Colors.green,
                        function: () {}),
                    actionButton(
                        icon: Icons.edit,
                        color: Colors.blueAccent,
                        function: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              // return DialogDelete(
                              //   todoDetails: todoDetails,
                              // );
                              return DialogEdit(
                                todoDetails: todoDetails,
                              );
                            },
                          );
                        }),
                    actionButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        function: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DialogDelete(
                                todoDetails: todoDetails,
                              );
                            },
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
        actionExtentRatio: 0.55,
        child: Container(
          height: 70,
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: bgTodoContainerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              todoDetails.doing,
              style: TextStyle(
                  fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

  Widget actionButton(
      {@required IconData icon,
      @required Color color,
      @required Function function}) {
    return GestureDetector(
      onTap: function,
      child: Container(
        child: Icon(
          icon,
          size: 30.0,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        height: 50,
        width: 50,
        margin: EdgeInsets.only(left: 10),
      ),
    );
  }
}
