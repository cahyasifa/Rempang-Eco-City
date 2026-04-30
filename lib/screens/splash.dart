import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs   = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('isLogin') ?? false;
    final role    = prefs.getString('role') ?? '';

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (isLogin && role == 'produsen') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1D9E75),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.waves, size: 44, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text('Rempang Eco City',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            const Text('Sistem Informasi Hasil Laut',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Color(0xFF1D9E75),
            ),
          ],
        ),
      ),
    );
  }
}