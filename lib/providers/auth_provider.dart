import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // Add authentication logic here
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login(String username, String password) {
    // TODO: Implement login logic
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
} 