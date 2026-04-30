import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'admin/admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure       = true;
  bool _isLoading     = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('users') ?? [];

    bool found = false;
    String? role;

    for (var user in users) {
      final data = Uri.splitQueryString(user);
      if (data['email']    == _emailCtrl.text.trim() &&
          data['password'] == _passwordCtrl.text.trim()) {
        found = true;
        role  = data['role'];
        await prefs.setBool('isLogin', true);
        await prefs.setString('role',  role ?? '');
        await prefs.setString('nama',  data['nama']  ?? '');
        await prefs.setString('email', data['email'] ?? '');
        break;
      }
    }

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (found) {
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        );
      } else if (role == 'produsen') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Email atau kata sandi tidak sesuai.\nHubungi admin untuk mendapatkan akun.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Logo
              Image.asset('assets/logo.png', height: 100, fit: BoxFit.contain),
              const SizedBox(height: 8),
              const Text(
                'Portal Rempang Eco City',
                style: TextStyle(fontSize: 14, color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),

              // Card form
              Container(
                width: 400,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFDFD),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE4E4E4), width: 0.5),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Masuk',
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF222222))),
                      const SizedBox(height: 4),
                      const Text('Masukkan email dan kata sandi Anda',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 24),

                      // Email
                      const Text('Email',
                          style: TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 13),
                        decoration: _deco('Masukkan email', Icons.email_outlined),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email wajib diisi';
                          if (!v.contains('@')) return 'Format email tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Password
                      const Text('Kata Sandi',
                          style: TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54)),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscure,
                        style: const TextStyle(fontSize: 13),
                        decoration:
                            _deco('Masukkan kata sandi', Icons.lock_outline)
                                .copyWith(
                          suffixIcon: GestureDetector(
                            onTap: () =>
                                setState(() => _obscure = !_obscure),
                            child: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Kata sandi wajib diisi';
                          if (v.length < 6) return 'Minimal 6 karakter';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Tombol masuk
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3A6FA8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 18, height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : const Text('Masuk',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF2F8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(children: [
                          Icon(Icons.info_outline,
                              size: 14, color: Color(0xFF3A6FA8)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Belum punya akun? Hubungi admin untuk mendaftarkan diri sebagai produsen.',
                              style: TextStyle(
                                  fontSize: 11, color: Color(0xFF3A6FA8)),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _deco(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        prefixIcon: Icon(icon, size: 18, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Color(0xFFE4E4E4), width: 0.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Color(0xFFE4E4E4), width: 0.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Color(0xFF1D9E75), width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1)),
      );
}