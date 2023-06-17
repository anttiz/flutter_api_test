import 'dart:convert';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../model/todo_item.dart';

class TodoService {
  List<TodoItem> _todos = [];
    // fake todos to save number of API requests
  final _fake = true;
  get isFake => _fake;

  TodoService() {
    if (_fake) {
      _todos = <TodoItem>[
        TodoItem(name: 'test1 pretty long name', todoId: Uuid().v1()),
        TodoItem(name: 'test2 pretty long name', todoId: Uuid().v1()),
      ];
    }
  }

  Future<List<TodoItem>> getTodoItems() async {
    if (_fake) {
      return _todos;
    }
    var us = UserService();
    await us.init();
    var session = await us.getSession();
    Map<String, String> headers = Map.from(
        {'Authorization': 'Bearer ${session!.getIdToken().getJwtToken()}'});
    final response = await http.get(Uri.parse(dotenv.env['TODO_ENDPOINT']!),
        headers: headers);
    final json = jsonDecode(response.body) as List;
    List<TodoItem> items =
        json.map((model) => TodoItem.fromJson(model)).toList();
    return items;
  }

  Future<TodoItem> addTodo(String name) async {
    if (_fake) {
      var item = TodoItem(todoId: Uuid().v1(), name: name);
      _todos.add(item);
      return item;
    }
    var us = UserService();
    await us.init();
    var session = await us.getSession();
    Map data = {'name': name};
    var body = json.encode(data);
    Map<String, String> headers = Map.from(
        {'Authorization': 'Bearer ${session!.getIdToken().getJwtToken()}'});
    final response = await http.post(Uri.parse(dotenv.env['TODO_ENDPOINT']!),
        headers: headers, body: body);
    return TodoItem.fromJson(json.decode(response.body));
  }

  Future<void> deleteTodo(String id) async {
    if (_fake) {
      _todos.removeWhere((element) => element.todoId == id);
      return;
    }
    var us = UserService();
    await us.init();
    var session = await us.getSession();
    Map data = {'id': id};
    var body = json.encode(data);
    Map<String, String> headers = Map.from(
        {'Authorization': 'Bearer ${session!.getIdToken().getJwtToken()}'});
    await http.delete(Uri.parse(dotenv.env['TODO_ENDPOINT']!),
        headers: headers, body: body);
  }
}
