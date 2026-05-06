import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../providers/user_provider.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _birthCtrl;
  bool _edited = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user!;
    _nameCtrl  = TextEditingController(text: user.name);
    _phoneCtrl = TextEditingController(text: user.phone);
    _emailCtrl = TextEditingController(text: user.email);
    _birthCtrl = TextEditingController(text: user.birthDate);
    for (final c in [_nameCtrl, _phoneCtrl, _emailCtrl, _birthCtrl]) {
      c.addListener(() => setState(() => _edited = true));
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _birthCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    context.read<UserProvider>().updateUser(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      birthDate: _birthCtrl.text.trim(),
    );
    setState(() => _edited = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil disimpan'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user!;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        automaticallyImplyLeading: false,
        // Logo saja, tanpa tombol setting
        title: const AppLogo(height: 40, white: true),
      ),
      body: SingleChildScrollView(
        child: Column(children: [

          // ── Header profil ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 28),
            decoration: const BoxDecoration(color: AppColors.blue),
            child: Column(children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: AppColors.white.withOpacity(0.25),
                child: Text(
                  user.name.isNotEmpty
                      ? user.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.name.isEmpty ? 'Nama Pengguna' : user.name,
                style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(user.email,
                  style: const TextStyle(
                      color: AppColors.white, fontSize: 13)),
              const SizedBox(height: 10),
              // Badge Mitra Hilir
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.white.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        color: AppColors.white, size: 14),
                    SizedBox(width: 6),
                    Text('Mitra Hilir',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ]),
          ),

          const SizedBox(height: 20),

          // ── Form edit profil ──
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
                  _field('Nama Lengkap', _nameCtrl,
                      icon: Icons.person_outline),
                  const SizedBox(height: 14),
                  _field('Nomor Telepon', _phoneCtrl,
                      icon: Icons.phone_outlined,
                      type: TextInputType.phone),
                  const SizedBox(height: 14),
                  _field('Email', _emailCtrl,
                      icon: Icons.email_outlined,
                      type: TextInputType.emailAddress),
                  const SizedBox(height: 14),
                  _field('Tanggal Lahir', _birthCtrl,
                      icon: Icons.cake_outlined),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity, height: 48,
                    child: ElevatedButton(
                      onPressed: _edited ? _simpan : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _edited
                            ? AppColors.blue
                            : AppColors.divider,
                        foregroundColor: AppColors.white,
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

          // ── Keluar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity, height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<UserProvider>().logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.logout,
                    color: AppColors.deleteRed, size: 18),
                label: const Text('Keluar',
                    style: TextStyle(
                        color: AppColors.deleteRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.deleteRed),
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

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType? type, IconData? icon}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: type,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 14),
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.iconGrey, size: 20)
                : null,
          ),
        ),
      ]);
}