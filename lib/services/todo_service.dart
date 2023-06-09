import 'dart:convert';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/todo_item.dart';

class TodoService {
  TodoService();

  Future<List<TodoItem>> getTodoItems() async {
    // fake todos to save number of API requests
    const fake = false;
    if (fake) {
      return <TodoItem>[
        TodoItem(name: 'test1 pretty long name', todoId: 'id1-xxx-yyy-zzz'),
        TodoItem(name: 'test2 pretty long name', todoId: 'id2-xxx-yyy-zzz'),
      ];
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
}
