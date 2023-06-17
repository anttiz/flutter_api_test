import 'package:flutter/material.dart';

class HomeContents extends StatelessWidget {
  const HomeContents({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Text('Todo app home page.',
          style: textTheme.headlineMedium),
    );
  }
}
