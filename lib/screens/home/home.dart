import 'package:flutter/material.dart';
import 'package:uitodo/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: bgAppBarColor,
          automaticallyImplyLeading: false,
          title: Text("Todo List"),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: bgBodyColor,
          child: Container(
            margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
            child: ListView(
              children: <Widget>[
                todoContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container todoContainer() => Container(
        child: Column(
          children: [
            todoDate(),
            SizedBox(
              height: 20,
            ),
            todoContents(),
          ],
        ),
      );

  Widget todoDate() => GestureDetector(
        onTap: () {},
        child: Container(
          child: Row(
            children: [
              Text(
                'Today',
                style: TextStyle(fontSize: 14, color: textColor),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: textColor,
                size: 20,
              ),
            ],
          ),
        ),
      );

  Widget todoContents() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            todo(),
          ],
        ),
      );

  Widget todo() => Container(
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
            'Watch Attack on Titan',
            style: TextStyle(
                fontSize: 16, color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      );
}
