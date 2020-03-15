import 'package:flutter/material.dart';
import 'package:todo/models/item.dart';

class TodoItem extends StatelessWidget {
  final Item todoItem;

  TodoItem({@required this.todoItem}) {
    print("todoItem title: " + this.todoItem.title.toString());
    print("todoItem done: " + this.todoItem.done.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Icon(
              todoItem.done ? Icons.check_circle : Icons.check_circle_outline,
              color: todoItem.done ? Colors.green : Colors.grey,
            ),
          ),
          Flexible(
            child: Text(
              todoItem.title,
              style: Theme.of(context).textTheme.title,
            ),
          )
        ],
      ),
    );
  }
}
