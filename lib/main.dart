import 'package:flutter/material.dart';
import 'package:flutter_api_test/pages/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MyAppState extends ChangeNotifier {
  var loggedIn = false;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Test app',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: LoginPage()
      ),
    );
  }
}
