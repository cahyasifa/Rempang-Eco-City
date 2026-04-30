import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey        = GlobalKey<FormState>();
  final _namaCtrl       = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  final _konfirmasiCtrl = TextEditingController();
  String _role          = 'produsen';
  bool _obscure         = true;
  bool _obscureK        = true;
  bool _isLoading       = false;

  @override
  void dispose() {
    _namaCtrl.dispose(); _emailCtrl.dispose();
    _passwordCtrl.dispose(); _konfirmasiCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordCtrl.text != _konfirmasiCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi tidak cocok'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('users') ?? [];

    // Cek email sudah terdaftar
    for (var u in users) {
      final d = Uri.splitQueryString(u);
      if (d['email'] == _emailCtrl.text.trim()) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email sudah terdaftar'), backgroundColor: Colors.red),
        );
        return;
      }
    }

    // Simpan akun baru
    users.add(Uri(queryParameters: {
      'nama':     _namaCtrl.text.trim(),
      'email':    _emailCtrl.text.trim(),
      'password': _passwordCtrl.text.trim(),
      'role':     _role,
    }).query);
    await prefs.setStringList('users', users);

    setState(() => _isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Akun berhasil dibuat! Silakan login'),
        backgroundColor: Color(0xFF1D9E75),
      ),
    );
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
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
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1D9E75),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.waves, size: 36, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text('Rempang Eco City',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 32),

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
                      const Text('Daftar Akun',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      const Text('Buat akun baru untuk mengakses sistem',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 24),

                      // Role
                      const Text('Daftar sebagai',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54)),
                      const SizedBox(height: 8),
                      Row(children: [
                        _RoleChip(label: 'Produsen', icon: Icons.set_meal_outlined,
                            selected: _role == 'produsen', onTap: () => setState(() => _role = 'produsen')),
                        const SizedBox(width: 10),
                        _RoleChip(label: 'Mitra Hilir', icon: Icons.store_outlined,
                            selected: _role == 'mitra', onTap: () => setState(() => _role = 'mitra')),
                      ]),
                      const SizedBox(height: 20),

                      _label('Nama Lengkap'),
                      _field(_namaCtrl, 'Masukkan nama lengkap', Icons.person_outline,
                          validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null),
                      const SizedBox(height: 14),

                      _label('Email'),
                      _field(_emailCtrl, 'Masukkan email', Icons.email_outlined,
                          type: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Email wajib diisi';
                            if (!v.contains('@')) return 'Format email tidak valid';
                            return null;
                          }),
                      const SizedBox(height: 14),

                      _label('Kata Sandi'),
                      _fieldObscure(_passwordCtrl, 'Min. 6 karakter', _obscure,
                          () => setState(() => _obscure = !_obscure),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Kata sandi wajib diisi';
                            if (v.length < 6) return 'Minimal 6 karakter';
                            return null;
                          }),
                      const SizedBox(height: 14),

                      _label('Konfirmasi Kata Sandi'),
                      _fieldObscure(_konfirmasiCtrl, 'Ulangi kata sandi', _obscureK,
                          () => setState(() => _obscureK = !_obscureK),
                          validator: (v) => (v == null || v.isEmpty) ? 'Konfirmasi wajib diisi' : null),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D9E75),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: _isLoading
                              ? const SizedBox(width: 18, height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Daftar',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Text('Sudah punya akun? ',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text('Masuk',
                              style: TextStyle(fontSize: 12, color: Color(0xFF288AE7), fontWeight: FontWeight.w600)),
                        ),
                      ]),
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

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54)),
  );

  Widget _field(TextEditingController ctrl, String hint, IconData icon,
      {TextInputType type = TextInputType.text, String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      style: const TextStyle(fontSize: 13),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        prefixIcon: Icon(icon, size: 18, color: Colors.grey),
        filled: true, fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE4E4E4), width: 0.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE4E4E4), width: 0.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF1D9E75), width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red, width: 1)),
      ),
    );
  }

  Widget _fieldObscure(TextEditingController ctrl, String hint, bool obscure,
      VoidCallback toggle, {String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(fontSize: 13),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        prefixIcon: const Icon(Icons.lock_outline, size: 18, color: Colors.grey),
        suffixIcon: GestureDetector(
          onTap: toggle,
          child: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              size: 18, color: Colors.grey),
        ),
        filled: true, fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE4E4E4), width: 0.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE4E4E4), width: 0.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF1D9E75), width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red, width: 1)),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _RoleChip({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1D9E75).withOpacity(0.1) : const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? const Color(0xFF1D9E75) : const Color(0xFFE4E4E4),
              width: selected ? 1.5 : 0.5,
            ),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 22, color: selected ? const Color(0xFF1D9E75) : Colors.grey),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected ? const Color(0xFF1D9E75) : Colors.grey,
            )),
          ]),
        ),
      ),
    );
  }
}