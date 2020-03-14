import 'package:flutter/material.dart';
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
    todoItems.add(Item(title: "⬅️ Swipe left to delete", done: false));
    todoItems.add(Item(title: "Swipe right to mark as done ➡️", done: false));
    todoItems.add(Item(title: "Learn how to use a todo app ✔️", done: false));

    doneItems.add(Item(title: '⬅️ Swipe left to delete', done: true));
    doneItems.add(Item(title: "Swipe right to mark as undone ➡️", done: true));
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
  }

  void remove(int index, List<Item> list) {
    setState(() {
      list.removeAt(index);
    });
  }

  void doTask(int index) {
    setState(() {
      widget.todoItems[index].done = true;
      widget.doneItems.add(widget.todoItems[index]);
      widget.todoItems.removeAt(index);
    });

    print(widget.todoItems);
    print(widget.doneItems);
  }

  void undoTask(int index) {
    setState(() {
      Item item = widget.doneItems[index];
      item.done = false;
      widget.todoItems.add(item);
      widget.doneItems.removeAt(index);
    });
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
                      remove(index, widget.todoItems);
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
                      remove(index, widget.doneItems);
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
