import 'package:flutter/material.dart';
import 'package:todo/models/item.dart';

class DoneItem extends StatelessWidget {
  final Item doneItem;

  DoneItem({@required this.doneItem}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Icon(
              doneItem.done ? Icons.check_circle : Icons.check_circle_outline,
              color: doneItem.done ? Colors.green : Colors.grey,
            ),
          ),
          Flexible(
            child: Text(
              doneItem.title,
              style: Theme.of(context).textTheme.title,
            ),
          )
        ],
      ),
    );
  }
}
