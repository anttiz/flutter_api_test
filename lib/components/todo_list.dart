import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todo_item.dart';
import '../provider/todo_provider.dart';

class TodoList extends StatelessWidget {
  final List<TodoItem> items;

  TodoList(this.items);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(builder: (context, provider, child) {
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
                        trailing: ExcludeSemantics(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete, size: 18),
                            label: Text('Delete'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  /*
                                  if (states.contains(MaterialState.pressed)) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .errorContainer
                                        .withOpacity(0.5);
                                  }
                                  */
                                  return Theme.of(context).colorScheme.error;
                                },
                              ),
                              /*
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                return Colors.white;
                              }),
                              */
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                return Theme.of(context).colorScheme.onError;
                              }),
                            ),
                            onPressed: () async {
                              await provider.deleteTodo(entry.value.todoId);
                            },
                          ),
                        ),
                      ))
                  .toList()),
        ],
      );
    });
  }
}
