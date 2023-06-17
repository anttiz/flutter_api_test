import 'package:flutter/material.dart';
import 'package:flutter_api_test/pages/home_page.dart';
import 'package:flutter_api_test/pages/login_page.dart';
import 'package:flutter_api_test/provider/todo_provider.dart';
import 'package:flutter_api_test/provider/user_provider.dart';
import 'package:flutter_api_test/services/user_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'color_schemes.g.dart';

void main() async {
  await dotenv.load();
  var us = UserService();
  await us.init();
  var user = await us.getCurrentUser();
  var initialRoute = user != null ? '/home' : '/';
  runApp(MainApp(initialRoute:initialRoute));
}

class MyAppState extends ChangeNotifier {
  var _loggedIn = false;
  bool get isLoggedIn => _loggedIn;

  void setLoggedIn(bool loggedIn) {
    _loggedIn = loggedIn;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}

class MainApp extends StatelessWidget {
  final String initialRoute;
  MainApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyAppState()),
        ChangeNotifierProvider(
          create: (context) => TodoProvider()),
        ChangeNotifierProvider(
          create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Test app',
        initialRoute: initialRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        themeMode: ThemeMode.light, // Default is system
        routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
      ),
    );
  }
}
