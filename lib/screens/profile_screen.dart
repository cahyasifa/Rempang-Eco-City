import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nama  = '';
  String _email = '';
  String _role  = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama  = prefs.getString('nama')  ?? 'Produsen';
      _email = prefs.getString('email') ?? '-';
      _role  = prefs.getString('role')  ?? 'produsen';
    });
  }

  Future<void> _logout() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Keluar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: const Text('Apakah kamu yakin ingin keluar dari akun ini?',
            style: TextStyle(fontSize: 13, color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', false);
    await prefs.setString('role', '');
    await prefs.setString('nama', '');
    await prefs.setString('email', '');

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFFE4E4E4)),
        ),
        title: const Text('Profil Saya',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ── Avatar & nama ────────────────────────────────────────────
          Center(
            child: Column(
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFFE1F5EE),
                  child: Text(
                    _nama.isNotEmpty ? _nama[0].toUpperCase() : 'P',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D9E75),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(_nama,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF222222))),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5EE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _role == 'produsen' ? 'Produsen / Nelayan' : _role,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F6E56)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // ── Info akun ────────────────────────────────────────────────
          const Text('Informasi Akun',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
          const SizedBox(height: 10),
          _InfoCard(icon: Icons.person_outline, label: 'Nama',  value: _nama),
          const SizedBox(height: 8),
          _InfoCard(icon: Icons.email_outlined,  label: 'Email', value: _email.isEmpty ? '-' : _email),
          const SizedBox(height: 8),
          _InfoCard(icon: Icons.badge_outlined,  label: 'Role',  value: _role == 'produsen' ? 'Produsen' : _role),
          const SizedBox(height: 24),

          // ── Pengaturan ───────────────────────────────────────────────
          const Text('Pengaturan',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
          const SizedBox(height: 10),
          _MenuTile(
            icon: Icons.lock_outline,
            label: 'Ubah Kata Sandi',
            onTap: () => _showUbahPassword(context),
          ),
          const SizedBox(height: 8),
          _MenuTile(
            icon: Icons.info_outline,
            label: 'Tentang Aplikasi',
            onTap: () => _showTentang(context),
          ),
          const SizedBox(height: 24),

          // ── Tombol logout ────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, size: 18, color: Colors.red),
              label: const Text('Keluar dari Akun',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 1),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text('Rempang Eco City v1.0.0',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showUbahPassword(BuildContext context) {
    final lamaCtrl = TextEditingController();
    final baruCtrl = TextEditingController();
    final konfCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Ubah Kata Sandi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogField(lamaCtrl, 'Kata sandi lama'),
            const SizedBox(height: 10),
            _dialogField(baruCtrl, 'Kata sandi baru', obscure: true),
            const SizedBox(height: 10),
            _dialogField(konfCtrl, 'Konfirmasi kata sandi baru', obscure: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (baruCtrl.text != konfCtrl.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kata sandi tidak cocok'), backgroundColor: Colors.red),
                );
                return;
              }
              if (baruCtrl.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Minimal 6 karakter'), backgroundColor: Colors.red),
                );
                return;
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kata sandi berhasil diubah'),
                  backgroundColor: Color(0xFF1D9E75),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D9E75),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showTentang(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Tentang Aplikasi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rempang Eco City',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('Sistem Informasi Hasil Laut',
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            SizedBox(height: 12),
            Text('Versi: 1.0.0', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text('Platform: Flutter', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D9E75),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(TextEditingController ctrl, String hint,
      {bool obscure = false}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE4E4E4), width: 0.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE4E4E4), width: 0.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1D9E75), width: 1.5)),
      ),
    );
  }
}

// ── Info Card ──────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE4E4E4), width: 0.5),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFFEDF2F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF3A6FA8)),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF222222))),
        ]),
      ]),
    );
  }
}

// ── Menu Tile ──────────────────────────────────────────────────────────────────
class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFDFD),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE4E4E4), width: 0.5),
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF2F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF3A6FA8)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF222222))),
          ),
          const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        ]),
      ),
    );
  }
}