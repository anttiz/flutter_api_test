import 'dart:convert';
import 'package:flutter_api_test/services/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TodoItem {
  String name;
  String todoId;
  TodoItem(this.name, this.todoId);

  factory TodoItem.fromJson(json) {
    return TodoItem(json['name'], json['todoId']);
  }

  static List<String> columns = ['name', 'todoId'];

  Map<String, dynamic> _toMap() {
    return {
      'name': name,
      'todoId': todoId,
    };
  }

  dynamic get(String propertyName) {
    var mapRep = _toMap();
    if (mapRep.containsKey(propertyName)) {
      return mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}

class TodoService {
  TodoService();

  Future<List<TodoItem>> getTodoItems() async {
    var us = UserService();
    await us.init();
    var session = await us.getSession();
    Map<String, String> headers = Map.from(
        {'Authorization': 'Bearer ${session!.getIdToken().getJwtToken()}'});
    final response = await http.get(Uri.parse(dotenv.env['TODO_ENDPOINT']!),
        headers: headers);
    Iterable l = json.decode(response.body);
    List<TodoItem> items =
        List<TodoItem>.from(l.map((model) => TodoItem.fromJson(model)));
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
