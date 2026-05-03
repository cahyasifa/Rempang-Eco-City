import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  // Akun bawaan: admin + beberapa produsen contoh
  final List<UserModel> _registeredUsers = [
    // ── Admin ──
    UserModel(
      name: 'Admin',
      email: 'admin@rempang.id',
      password: 'admin123',
      role: 'admin',
    ),
    // ── Produsen (dibuat oleh admin) ──
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

  // Daftar produsen (untuk ditampilkan di admin)
  List<UserModel> get produsenList =>
      _registeredUsers.where((u) => u.role == 'produsen').toList();

  bool register(UserModel newUser) {
    final exists = _registeredUsers.any((u) => u.email == newUser.email);
    if (exists) return false;
    _registeredUsers.add(newUser);
    notifyListeners();
    return true;
  }

  // Admin bisa tambah akun produsen
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
      role: _user!.role,
    );
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}