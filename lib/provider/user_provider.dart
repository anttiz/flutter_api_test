import 'package:flutter/material.dart';

import '../model/user.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user = User();
  User? get user => _user;
  set user(User? user) {
    _user = user;
  }

  Future<void> getUser() async {
    await UserService.init();
    final response = await UserService.getCurrentUser();
    if (response != null) {
      _user = response;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await UserService.signOut();
    _user = null;
    notifyListeners();
  }

  Future <void> login(String username, String password) async {
    _user = await UserService.login(username, password);
    notifyListeners();
  }
}
