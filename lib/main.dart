import 'package:flutter/material.dart';
import 'package:flutter_api_test/pages/home_page.dart';
import 'package:flutter_api_test/pages/login_page.dart';
import 'package:flutter_api_test/provider/todo_provider.dart';
import 'package:flutter_api_test/services/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load();
  var service = UserService();
  await service.init();
  var user = await service.getCurrentUser();
  var initialRoute = user != null ? '/home' : '/';
  runApp(MainApp(initialRoute:initialRoute, user: user));
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
  final User? user;

  MainApp({required this.initialRoute, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyAppState()),
        ChangeNotifierProvider(
          create: (context) => TodoProvider()),
      ],
      child: MaterialApp(
        title: 'Test app',
        initialRoute: initialRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(user: user!),
      },
      ),
    );
  }
}
