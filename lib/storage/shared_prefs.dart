import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

Future<void> saveTodos(List<Todo> todos) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> encodedTodos = todos.map((todo) =>
    jsonEncode({
      'id': todo.id,
      'title': todo.title,
      'isDone': todo.isDone,
    })
  ).toList();

  prefs.setStringList('todos', encodedTodos);
}

Future<List<Todo>> loadTodos() async {
  final prefs = await SharedPreferences.getInstance();

  final List<String>? stored = prefs.getStringList('todos');

  if(stored == null) return [];

  return stored.map((str) {
    final map = jsonDecode(str);
    return Todo(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone']
    );
  }).toList();
}