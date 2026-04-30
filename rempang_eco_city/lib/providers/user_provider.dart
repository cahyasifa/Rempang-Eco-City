import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final List<UserModel> _registeredUsers = [];

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  bool register(UserModel newUser) {
    final exists =
        _registeredUsers.any((u) => u.email == newUser.email);
    if (exists) return false;
    _registeredUsers.add(newUser);
    return true;
  }

  UserModel? login(String email, String password) {
    try {
      final found = _registeredUsers.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      _user = found;
      notifyListeners();
      return found;
    } catch (_) {
      return null;
    }
  }

  void updateUser({
    String? name,
    String? phone,
    String? email,
    String? birthDate,
  }) {
    if (_user == null) return;
    _user = UserModel(
      name: name ?? _user!.name,
      email: email ?? _user!.email,
      phone: phone ?? _user!.phone,
      birthDate: birthDate ?? _user!.birthDate,
      password: _user!.password,
    );
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}