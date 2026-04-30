import 'package:flutter/material.dart';

class UserAccount {
  final String nama;
  final String email;
  final String password;
  final String role; // 'produsen' atau 'mitra_hilir'
  final String jenisUsaha;
  bool isAktif;

  UserAccount({
    required this.nama,
    required this.email,
    required this.password,
    required this.role,
    required this.jenisUsaha,
    this.isAktif = true,
  });
}

class AccountProvider extends ChangeNotifier {
  // Data akun awal (yang dulu hardcode di main.dart dipindah ke sini)
  final List<UserAccount> _accounts = [
    UserAccount(
      nama: 'KUB Nelayan Rempang',
      email: 'kub.nelayan@rempang.id',
      password: 'produsen123',
      role: 'produsen',
      jenisUsaha: 'Nelayan',
    ),
    UserAccount(
      nama: 'KUB Bahari Galang',
      email: 'kub.bahari@rempang.id',
      password: 'produsen123',
      role: 'produsen',
      jenisUsaha: 'Nelayan',
    ),
    UserAccount(
      nama: 'UD Hasil Laut',
      email: 'ud.hasillaut@rempang.id',
      password: 'produsen123',
      role: 'produsen',
      jenisUsaha: 'Distributor',
    ),
  ];

  List<UserAccount> get accounts => List.unmodifiable(_accounts);

  List<UserAccount> get produsenAccounts =>
      _accounts.where((a) => a.role == 'produsen').toList();

  List<UserAccount> get mitraAccounts =>
      _accounts.where((a) => a.role == 'mitra_hilir').toList();

  // Dipanggil admin saat buat akun baru
  void tambahAkun(UserAccount akun) {
    _accounts.add(akun);
    notifyListeners();
  }

  // Toggle aktif/nonaktif
  void toggleAktif(String email) {
    final idx = _accounts.indexWhere((a) => a.email == email);
    if (idx != -1) {
      _accounts[idx].isAktif = !_accounts[idx].isAktif;
      notifyListeners();
    }
  }

  // Reset password oleh admin
  void resetPassword(String email, String passwordBaru) {
    final idx = _accounts.indexWhere((a) => a.email == email);
    if (idx != -1) {
      _accounts[idx] = UserAccount(
        nama: _accounts[idx].nama,
        email: _accounts[idx].email,
        password: passwordBaru,
        role: _accounts[idx].role,
        jenisUsaha: _accounts[idx].jenisUsaha,
        isAktif: _accounts[idx].isAktif,
      );
      notifyListeners();
    }
  }

  // Dipanggil saat login — cek email, password, dan status aktif
  UserAccount? login(String email, String password) {
    try {
      return _accounts.firstWhere(
        (a) => a.email == email && a.password == password && a.isAktif,
      );
    } catch (_) {
      return null; // null = login gagal
    }
  }
}