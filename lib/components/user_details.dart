import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class UserDetails extends StatelessWidget {
  UserDetails();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Consumer<UserProvider>(builder: (context, provider, child) {
          if (provider.user == null || provider.user?.name == null) {
            return Column();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User: ${provider.user!.name!}'),
              Text('Email: ${provider.user!.email!}'),
            ],
          );
        }));
  }
}
