import 'package:flutter/material.dart';

import '../model/todo_item.dart';
import '../services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  final _service = TodoService();
  bool isLoading = false;
  List<TodoItem> _todos = [];
  List<TodoItem> get todos => _todos;

  Future<void> addTodo(String name) async {
    // isLoading = true;
    // notifyListeners();

    final response = await _service.addTodo(name);
    if (!_service.isFake) {
      _todos.add(response);
    }
    notifyListeners();
  }

  Future<void> getAllTodos() async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getTodoItems();
    _todos = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTodo(String id) async {
    await _service.deleteTodo(id);
    _todos.removeWhere((element) => element.todoId == id);
    notifyListeners();
  }
}
