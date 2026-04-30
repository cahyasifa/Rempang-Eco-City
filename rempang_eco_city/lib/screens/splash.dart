import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'dashboard_mitra.dart';
import 'dashboard_produsen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    bool isLogin = prefs.getBool('isLogin') ?? false;
    String role = prefs.getString('role') ?? "mitra";

    await Future.delayed(Duration(seconds: 3));

    if (isLogin) {
      if (role == "produsen") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardProdusen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardMitra()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EBDD),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🌿 ICON
            Icon(Icons.eco, size: 70, color: Colors.green),

            SizedBox(height: 15),

            // 🌿 TITLE
            Text(
              "Rempang Eco City 🌿",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Marketplace Hasil Laut",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}