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
}

class TodoService {
  TodoService();

  Future<List<TodoItem>> getTodoItems() async {
    var us = UserService();
    await us.init();
    var session = await us.getSession();
    Map<String, String> headers = Map.from(
        {'Authorization': 'Bearer ${session!.getIdToken().getJwtToken()}'});
    /*
    AwsSigV4Client awsSigV4Client = AwsSigV4Client(credentials!.accessKeyId!,
        credentials!.secretAccessKey!, dotenv.env['TODO_ENDPOINT']!,
        region: dotenv.env['REGION']!, sessionToken: credentials!.sessionToken);
    final signedRequest =
        SigV4Request(awsSigV4Client, method: 'GET', path: '/todo');
        */
    final response = await http.get(
        Uri.parse(dotenv.env['TODO_ENDPOINT']!),
        headers: headers
        // headers: signedRequest.headers as Map<String, String>);
    );
    Iterable l = json.decode(response.body);
    List<TodoItem> items = List<TodoItem>.from(l.map((model)=> TodoItem.fromJson(model)));
    return items;
  }
}
