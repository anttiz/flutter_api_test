import 'package:flutter/material.dart';

import '../model/user.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final _service = UserService();
  User? _user = User();
  User? get user => _user;
  set user(User? user) {
    _user = user;
  }

  Future<void> getUser() async {
    final response = await _service.getCurrentUser();
    if (response != null) {
      _user = response;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _service.signOut();
    _user = null;
    notifyListeners();
  }
}
