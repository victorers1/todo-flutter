import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var todoItems = new List<Item>();
  var doneItems = new List<Item>();

  HomePage() {
    todoItems = [];

    var d = new DateTime.now().toString();
    print("DateTime.now()" + d);
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  void add() {
    if (newTaskCtrl.text.isEmpty) return;
    setState(() {
      widget.todoItems.add(Item(title: newTaskCtrl.text, done: false));
      newTaskCtrl.clear();
    });

    saveTasks();
  }

  void removeTask(int index, List<Item> list) {
    setState(() {
      list.removeAt(index);
    });
    saveTasks();
  }

  void doTask(int index) {
    setState(() {
      widget.todoItems[index].done = true;
      widget.doneItems.add(widget.todoItems[index]);
      widget.todoItems.removeAt(index);
    });

    saveTasks();
  }

  void undoTask(int index) {
    setState(() {
      Item item = widget.doneItems[index];
      item.done = false;
      widget.todoItems.add(item);
      widget.doneItems.removeAt(index);
    });
    saveTasks();
  }

  Future checkFirstLaunch() async {
    var prefs = await SharedPreferences.getInstance();
    var isFirstLaunch = prefs.getBool('launch');

    print("isFirstLaunch: " + isFirstLaunch.toString());

    if (isFirstLaunch == null) {
      prefs.setBool('launch', false);
      loadFirstTasks();
    } else if (isFirstLaunch == false) {
      loadTasks();
    }
  }

  void loadFirstTasks() async {
    setState(() {
      widget.todoItems.add(Item(title: "⬅️ Swipe left to delete", done: false));
      widget.todoItems
          .add(Item(title: "Swipe right to mark as done ➡️", done: false));
      widget.todoItems
          .add(Item(title: "Dismiss previous tasks ✔️", done: false));

      widget.doneItems.add(Item(title: '⬅️ Swipe left to delete', done: true));
      widget.doneItems
          .add(Item(title: "Swipe right to mark as undone ➡️", done: true));
    });

    saveTasks();
    print("Loaded firsts tasks");
  }

  Future loadTasks() async {
    var prefs = await SharedPreferences.getInstance();
    var todo = prefs.getString('todo');
    var done = prefs.getString('done');

    if (todo != null) {
      Iterable decoded = jsonDecode(todo);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.todoItems = result;
      });
    }

    if (done != null) {
      Iterable decoded = jsonDecode(done);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.doneItems = result;
      });
    }

    print("Loaded previous tasks");
  }

  void saveTasks() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setString('todo', jsonEncode(widget.todoItems));
    await prefs.setString('done', jsonEncode(widget.doneItems));
  }

  _HomePageState() {
    checkFirstLaunch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            labelText: "Insert task here",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Text(
              'To do',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          new Expanded(
            child: ListView.builder(
              itemCount: widget.todoItems.length,
              itemBuilder: (BuildContext ctx, int index) {
                final item = widget.todoItems[index];
                return Dismissible(
                  key: Key(item.title),
                  child: CheckboxListTile(
                    title: Text(item.title),
                    value: item.done,
                    onChanged: (value) {
                      setState(() {
                        // item.done = value;
                        doTask(index);
                        print(value);
                      });
                    },
                  ),
                  background: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    color: Colors.green,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.done,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.delete_forever,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      removeTask(index, widget.todoItems);
                    } else if (direction == DismissDirection.startToEnd) {
                      doTask(index);
                    }
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Text(
              'Done',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          new Expanded(
            child: ListView.builder(
              itemCount: widget.doneItems.length,
              itemBuilder: (BuildContext ctx, int index) {
                final item = widget.doneItems[index];

                return Dismissible(
                  key: Key(item.title),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      item.title,
                      style: TextStyle(),
                    ),
                  ),
                  background: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    color: Colors.green,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.undo,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.delete_forever,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      removeTask(index, widget.doneItems);
                    } else if (direction == DismissDirection.startToEnd) {
                      undoTask(index);
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
