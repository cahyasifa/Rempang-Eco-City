import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _namaCtrl;
  late TextEditingController _teleponCtrl;
  late TextEditingController _passwordBaruCtrl;
  late TextEditingController _konfirmasiCtrl;

  bool _edited      = false;
  bool _obscureBaru = true;
  bool _obscureKonf = true;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user!;
    _namaCtrl         = TextEditingController(text: user.name);
    _teleponCtrl      = TextEditingController(text: user.phone ?? '');
    _passwordBaruCtrl = TextEditingController();
    _konfirmasiCtrl   = TextEditingController();

    for (final c in [_namaCtrl, _teleponCtrl, _passwordBaruCtrl, _konfirmasiCtrl]) {
      c.addListener(() { if (mounted) setState(() => _edited = true); });
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _teleponCtrl.dispose();
    _passwordBaruCtrl.dispose();
    _konfirmasiCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    // Validasi password baru kalau diisi
    if (_passwordBaruCtrl.text.isNotEmpty) {
      if (_passwordBaruCtrl.text.length < 6) {
        _snackbar('Kata sandi baru minimal 6 karakter', isError: true);
        return;
      }
      if (_passwordBaruCtrl.text != _konfirmasiCtrl.text) {
        _snackbar('Konfirmasi kata sandi tidak cocok', isError: true);
        return;
      }
    }

    if (_namaCtrl.text.trim().isEmpty) {
      _snackbar('Nama tidak boleh kosong', isError: true);
      return;
    }

    // Update via UserProvider
    context.read<UserProvider>().updateUser(
      name:     _namaCtrl.text.trim(),
      phone:    _teleponCtrl.text.trim(),
      password: _passwordBaruCtrl.text.isNotEmpty
          ? _passwordBaruCtrl.text
          : null,
    );

    setState(() {
      _edited = false;
      _passwordBaruCtrl.clear();
      _konfirmasiCtrl.clear();
    });

    _snackbar('Profil berhasil disimpan');
  }

  void _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Keluar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: const Text(
            'Apakah kamu yakin ingin keluar dari akun ini?',
            style: TextStyle(fontSize: 13, color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    if (!mounted) return;
    context.read<UserProvider>().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _snackbar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : AppColors.successGreen,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // watch supaya UI update saat updateUser dipanggil
    final user = context.watch<UserProvider>().user!;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profil Saya',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222222))),
            Text('Kelola informasi akunmu',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        toolbarHeight: 64,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFFE4E4E4)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [

          // ── Header avatar ──────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            decoration: const BoxDecoration(color: AppColors.blue),
            child: Column(children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white.withOpacity(0.25),
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'P',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // ← Nama sesuai user yang login
              Text(
                user.name.isEmpty ? 'Nama Pengguna' : user.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(height: 4),

              // ← Email sesuai user yang login
              Text(
                user.email,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 10),

              // ← Badge role sesuai user yang login
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      user.role == 'produsen'
                          ? Icons.set_meal_outlined
                          : user.role == 'admin'
                              ? Icons.admin_panel_settings_outlined
                              : Icons.store_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user.role == 'produsen'
                          ? 'Produsen'
                          : user.role == 'admin'
                              ? 'Admin'
                              : 'Mitra Hilir',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // ── Form edit profil ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Atur Profil',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 18),

                  // Nama
                  _fieldLabel('Nama Lengkap'),
                  _field(_namaCtrl, 'Masukkan nama lengkap',
                      Icons.person_outline),
                  const SizedBox(height: 14),

                  // Telepon
                  _fieldLabel('Nomor Telepon'),
                  _field(_teleponCtrl, 'Masukkan nomor telepon',
                      Icons.phone_outlined,
                      type: TextInputType.phone),
                  const SizedBox(height: 14),

                  // Email (readonly)
                  _fieldLabel('Email'),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFFE4E4E4), width: 0.5),
                    ),
                    child: Row(children: [
                      const Icon(Icons.email_outlined,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 10),
                      Text(user.email,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF2F8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Tidak dapat diubah',
                            style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF3A6FA8))),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  // Divider ubah password
                  Row(children: const [
                    Expanded(
                        child: Divider(color: Color(0xFFE4E4E4))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Ubah Kata Sandi',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ),
                    Expanded(
                        child: Divider(color: Color(0xFFE4E4E4))),
                  ]),
                  const SizedBox(height: 4),
                  const Text(
                      'Kosongkan jika tidak ingin mengubah kata sandi',
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 14),

                  // Password baru
                  _fieldLabel('Kata Sandi Baru'),
                  TextFormField(
                    controller: _passwordBaruCtrl,
                    obscureText: _obscureBaru,
                    style: const TextStyle(fontSize: 13),
                    decoration:
                        _deco('Masukkan kata sandi baru', Icons.lock_outline)
                            .copyWith(
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                            () => _obscureBaru = !_obscureBaru),
                        child: Icon(
                          _obscureBaru
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Konfirmasi password
                  _fieldLabel('Konfirmasi Kata Sandi Baru'),
                  TextFormField(
                    controller: _konfirmasiCtrl,
                    obscureText: _obscureKonf,
                    style: const TextStyle(fontSize: 13),
                    decoration:
                        _deco('Ulangi kata sandi baru', Icons.lock_outline)
                            .copyWith(
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                            () => _obscureKonf = !_obscureKonf),
                        child: Icon(
                          _obscureKonf
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Tombol simpan
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _edited ? _simpan : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _edited
                            ? AppColors.blue
                            : AppColors.divider,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledBackgroundColor: AppColors.divider,
                        disabledForegroundColor: Colors.grey,
                      ),
                      child: const Text('SIMPAN',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Tombol keluar ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout,
                    color: AppColors.deleteRed, size: 18),
                label: const Text('Keluar dari Akun',
                    style: TextStyle(
                        color: AppColors.deleteRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  side:
                      const BorderSide(color: AppColors.deleteRed),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
        ]),
      ),
    );
  }

  Widget _fieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary)),
      );

  Widget _field(TextEditingController ctrl, String hint, IconData icon,
      {TextInputType? type}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      style: const TextStyle(fontSize: 13, color: Color(0xFF222222)),
      decoration: _deco(hint, icon),
    );
  }

  InputDecoration _deco(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(fontSize: 13, color: Colors.grey),
        prefixIcon:
            Icon(icon, size: 18, color: AppColors.iconGrey),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 14),
      );
}