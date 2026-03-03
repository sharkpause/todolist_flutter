import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final void Function(Todo todo, bool isDone) onToggle;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: todo.isDone ? Colors.yellow[200] : null,

      child: 
        ListTile(
          title: Text(
            todo.title,
            
            style: TextStyle(

              decoration: todo.isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            
            ),
          ),
          
          trailing: Checkbox(
            value: todo.isDone,
            onChanged: (bool? value) {
              onToggle(todo, value ?? false);
            }
          ),

          // onChanged: (bool? value) {
          //   todo.isDone = value ?? false;

          //   (context as Element).markNeedsBuild();
          // },
        )
    );
  }
}