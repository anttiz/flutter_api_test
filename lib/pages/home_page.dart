import 'package:flutter/material.dart';
import 'package:flutter_api_test/components/home_contents.dart';
import 'package:flutter_api_test/pages/login_page.dart';
import 'package:flutter_api_test/pages/todo_page.dart';
import 'package:flutter_api_test/pages/user_page.dart';
import 'package:provider/provider.dart';

import '../components/dialog.dart';
import '../provider/todo_provider.dart';
import '../provider/user_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeContents(),
    TodoPage(),
    UserPage()
  ];

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    var bottomNavigationBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.add),
        label: 'Add todo',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.account_circle),
        label: 'account',
      ),
    ];
    return Consumer<UserProvider>(builder: (context, provider, child) {
      return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: _selectedIndex == 1 ? SizedBox(
            height: 100,
            width: 100,
            child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).restorablePush(dialogBuilder);
                },
                tooltip: "Add new TODO",
                child: Icon(Icons.add)),
          ):null,
          appBar: AppBar(
              elevation: 5,
              title: const Text('Todo list'),
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
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavigationBarItems,
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: textTheme.bodySmall!.fontSize!,
            unselectedFontSize: textTheme.bodySmall!.fontSize!,
            onTap: _onItemTapped,
            selectedItemColor: colorScheme.onPrimary,
            unselectedItemColor: colorScheme.onPrimary.withOpacity(0.38),
            backgroundColor: colorScheme.primary,
            elevation: 5,
          ));
    });
  }
}
