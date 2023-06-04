import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/todo_provider.dart';

Route<Object?> dialogBuilder(BuildContext context, Object? arguments) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Consumer<TodoProvider>(builder: (context, provider, child) {
            return AlertDialog(
              title: const Text('Add new TODO'),
              content: SizedBox(
                width: 400,
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: textEditingController,
                          validator: (value) {
                            return value!.isNotEmpty
                                ? null
                                : "Please enter TODO name";
                          },
                          decoration: InputDecoration(
                            hintText: "Name here",
                            border: OutlineInputBorder(),
                          ),
                        )
                      ],
                    )),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Add'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      await provider.addTodo(textEditingController.text);
                    }
                  },
                ),
              ],
            );
          });
        });
      });
}
