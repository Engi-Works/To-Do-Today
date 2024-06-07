import 'package:flutter/material.dart';
import 'util/dialog_box.dart';
import 'util/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 196, 244),
      appBar: AppBar(
          title: Text(
            'To Do Today',
            style: TextStyle(
                fontSize: 30,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3.4
                  ..color = const Color.fromARGB(255, 0, 0, 0)!
                  ..shader = ui.Gradient.linear(
                      const Offset(0, 20), const Offset(150, 20), <Color>[
                    const Color.fromARGB(255, 29, 29, 29),
                    const Color.fromARGB(255, 101, 101, 99),
                    const Color.fromARGB(255, 101, 119, 184),
                  ], <double>[
                    0.0,
                    0.5,
                    1.0
                  ])),
          ),
          elevation: 4,
          backgroundColor: const Color.fromARGB(255, 211, 138, 236)),

      floatingActionButton: FloatingActionButton(
          onPressed: createNewTask, child: const Icon(Icons.add)),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
