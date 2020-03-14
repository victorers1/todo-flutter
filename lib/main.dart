import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  var items = new List<Item>();

  HomePage() {
    items = [];
    items.add(Item(title: "⬅️ Swipe left to delete", done: false));
    items.add(Item(title: "Swipe right to mark as done ➡️", done: false));
    items.add(Item(title: "That's all for now ✔️", done: true));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  void add() {
    if (newTaskCtrl.text.isEmpty) return;
    setState(() {
      widget.items.add(Item(title: newTaskCtrl.text, done: false));
      newTaskCtrl.clear();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  void doTask(int index) {
    setState(() {
      widget.items[index].done = true;
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
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctx, int index) {
          final item = widget.items[index];

          return Dismissible(
            key: Key(item.title),
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
