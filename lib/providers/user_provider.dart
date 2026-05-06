import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  final List<UserModel> _registeredUsers = [
    UserModel(
      name: 'Admin',
      email: 'admin@rempang.id',
      password: 'admin123',
      role: 'admin',
    ),
    UserModel(
      name: 'Budi Santoso',
      email: 'budi@rempang.id',
      password: 'budi123',
      role: 'produsen',
    ),
    UserModel(
      name: 'Siti Aminah',
      email: 'siti@rempang.id',
      password: 'siti123',
      role: 'produsen',
    ),
  ];

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  String get role => _user?.role ?? 'mitra';

  List<UserModel> get produsenList =>
      _registeredUsers.where((u) => u.role == 'produsen').toList();

  bool register(UserModel newUser) {
    final exists = _registeredUsers.any((u) => u.email == newUser.email);
    if (exists) return false;
    _registeredUsers.add(newUser);
    notifyListeners();
    return true;
  }

  bool tambahProdusen({
    required String name,
    required String email,
    required String password,
  }) {
    return register(UserModel(
      name: name,
      email: email,
      password: password,
      role: 'produsen',
    ));
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

  // ← updateUser sekarang support update password
  void updateUser({
    String? name,
    String? phone,
    String? email,
    String? birthDate,
    String? password, // ← tambahan baru
  }) {
    if (_user == null) return;

    final updatedUser = UserModel(
      name:      name      ?? _user!.name,
      email:     email     ?? _user!.email,
      phone:     phone     ?? _user!.phone,
      birthDate: birthDate ?? _user!.birthDate,
      password:  password  ?? _user!.password, // ← pakai password baru kalau ada
      role:      _user!.role,
    );

    // Update juga di _registeredUsers supaya login berikutnya pakai password baru
    final idx = _registeredUsers.indexWhere((u) => u.email == _user!.email);
    if (idx != -1) {
      _registeredUsers[idx] = updatedUser;
    }

    _user = updatedUser;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}