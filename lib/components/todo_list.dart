import 'package:flutter/material.dart';
import 'package:flutter_api_test/services/todo.dart';

class TodoList extends StatelessWidget {
  final List<TodoItem> items;

  TodoList(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView(
            restorationId: 'list_demo_list_view',
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            children: items
                .asMap()
                .entries
                .map((entry) => ListTile(
                      leading: ExcludeSemantics(
                        child: CircleAvatar(child: Text('${entry.key + 1}')),
                      ),
                      title: Text(entry.value.name),
                      subtitle: Text(entry.value.todoId),
                    ))
                .toList()),
      ],
    );
  }
}
