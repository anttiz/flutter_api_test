import 'package:flutter/material.dart';
import 'package:flutter_api_test/components/user_details.dart';
import 'package:flutter_api_test/pages/login_page.dart';
import 'package:provider/provider.dart';

import '../components/dialog.dart';
import '../components/todo_list.dart';
import '../provider/todo_provider.dart';
import '../provider/user_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TodoProvider>(context, listen: false).getAllTodos();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, child) {
      return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: SizedBox(
            height: 100,
            width: 100,
            child: FloatingActionButton(
                // shape:
                // BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                onPressed: () {
                  Navigator.of(context).restorablePush(dialogBuilder);
                },
                tooltip: "Add new TODO",
                child: Icon(Icons.add)),
          ),
          appBar: AppBar(
              elevation: 4,
              title: const Text('Todo list'),
              leading: IconButton(
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              actions: [
                PopupMenuButton<Text>(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text(
                          'Log out',
                        ),
                        onTap: () async {
                          await provider.signOut();
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                      ),
                    ];
                  },
                )
              ]),
          body: Consumer<TodoProvider>(builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final todos = provider.todos;
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [UserDetails(todos.length), TodoList(todos)]);
          }));
    });
  }
}
