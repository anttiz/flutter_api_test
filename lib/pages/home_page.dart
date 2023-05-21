import 'package:flutter/material.dart';
import 'package:flutter_api_test/services/todo.dart';

import '../services/user.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> items = [];

  Future<TodoService> _getTodoService(BuildContext context) async {
    var todoService = TodoService();
    items = await todoService.getTodoItems();
    return todoService;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getTodoService(context),
        builder: (context, AsyncSnapshot<TodoService> snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Home Page'),
              ),
              body: Column(
                children: [
                  Text(widget.user.name!),
                  Text(widget.user.email!),
                  Text(items.length.toString())
                ],
              ));
        });
  }
}
