import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import '../storage/shared_prefs.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    loadTodos().then((list) {
      setState(() {
        _todos = list;
      });
    });
  }

  void _addTodo(String title) {
    setState(() {
      
      _todos.add(
        Todo(
          id: DateTime.now().toString(),
          title: title
        )
      );
      
      saveTodos(_todos);

    });
  }

  void _insertTodo(Todo todo, int index) {
    setState(() {
      _todos.insert(index, todo);
    });

    saveTodos(_todos);
  }

  void _removeTodo(Todo todo) {    
    setState(() {
      final removedTodo = todo;
      final removedIndex = _todos.indexOf(todo);

      _todos.remove(todo);

      final snackBar = SnackBar(
        content: Text('"${todo.title}" deleted'),
        action: SnackBarAction(
          label: 'Undo', 
          onPressed: () => _insertTodo(removedTodo, removedIndex)
        ),
        duration: Duration(seconds: 3),
        persist: false,
      );

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);

      saveTodos(_todos);
    });
  }

  Future<void> _displayAddTaskPopup(BuildContext context) {
    String newTask = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter task'),
            onChanged: (value) {
              newTask = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context) ,
              child: const Text('Cancel')
            ),
            TextButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  _addTodo(newTask);
                }
                Navigator.pop(context);
              },
              child: const Text('Add task')
            )
          ],
        );
      }
    );
  }

  Future<void> _displayEditTaskPopup(BuildContext context, Todo todo) {
    final controller = TextEditingController(text: todo.title);

    return showDialog(
      context: context,

      builder: (BuildContext context) {
        
        return AlertDialog(
          title: const Text('Edit task'),
          
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter task'),
            controller: controller,
          ),

          actions: [
            
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')
            ),

            TextButton(
              onPressed: () {
                final newText = controller.text.trim();
                if (newText.isNotEmpty) {
                  setState(() {
                    todo.title = newText;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Save')
            )

          ],
        );
      }
    );
  }

  void _markTodoDone(Todo todo, bool value) {
    setState(() {
      todo.isDone = value;

      saveTodos(_todos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: ListView(

        children: _todos.map((todo) => InkWell(
          onTap: () => _displayEditTaskPopup(context, todo),
          splashColor: Colors.grey[400],
          highlightColor: Colors.grey[300],
          
          child: GestureDetector(
            child: Dismissible(
              key: Key(todo.id),
              child: TodoItem(todo: todo, onToggle: _markTodoDone),
              onDismissed: (_) => _removeTodo(todo),
            )
          
          ),
        )).toList()),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAddTaskPopup(context),
        
        child: const Icon(Icons.add),
      ),
    
    );
  }
}