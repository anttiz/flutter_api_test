import 'package:flutter/material.dart';

import '../model/todo_item.dart';
import '../services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  bool isLoading = false;
  List<TodoItem> _todos = [];
  List<TodoItem> get todos => _todos;

  Future<void> addTodo(String name) async {
    // isLoading = true;
    // notifyListeners();

    await TodoService.addTodo(name);
    _todos = TodoService.todos;
    isLoading = false;
    notifyListeners();
  }

  Future<void> getAllTodos() async {
    isLoading = true;
    notifyListeners();

    final response = await TodoService.getTodoItems();
    _todos = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTodo(String id) async {
    // isLoading = true;
    // notifyListeners();
    await TodoService.deleteTodo(id);
    _todos.removeWhere((element) => element.todoId == id);
    isLoading = false;
    notifyListeners();
  }
}
