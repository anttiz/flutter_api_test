import 'package:flutter/material.dart';
import 'package:flutter_api_test/services/user.dart';

class UserDetails extends StatelessWidget {
  final User user;
  final int itemCount;

  UserDetails(this.user, this.itemCount);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User: ${user.name!}'),
          Text('Email: ${user.email!}'),
          Text('TODO items: ${itemCount.toString()}'),
        ],
      ),
    );
  }
}
