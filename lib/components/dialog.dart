import 'package:flutter/material.dart';

import '../services/todo.dart';

Route<Object?> dialogBuilder(BuildContext context, Object? arguments) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();

  return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add new TODO'),
            content: SizedBox(
              width: 400,
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Please enter TODO name";
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
                  if (_formKey.currentState!.validate()) {
                    var todoService = TodoService();
                    // ignore: unused_local_variable
                    var item = await todoService.addTodo(_textEditingController.text);
                    await todoService.getTodoItems();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
      });
}
