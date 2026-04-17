import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 🔥 LOGIN MULTI USER
  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> users = prefs.getStringList('users') ?? [];

    String inputEmail = emailController.text.trim();
    String inputPassword = passwordController.text.trim();

    if (inputEmail.isEmpty || inputPassword.isEmpty) {
      showMessage("Semua field wajib diisi");
      return;
    }

    for (var user in users) {
      final data = MapEncoding.fromUriEncoded(user);

      if (data["email"] == inputEmail &&
          data["password"] == inputPassword) {

        await prefs.setBool('isLogin', true);
        await prefs.setString('role', data["role"]!);

        if (data["role"] == "produsen") {
          Navigator.pushReplacementNamed(context, '/produsen');
        } else {
          Navigator.pushReplacementNamed(context, '/mitra');
        }
        return;
      }
    }

    showMessage("Akun tidak ditemukan");
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 320,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFFF1E4CF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Selamat Datang!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),

              // EMAIL
              TextField(
                controller: emailController,
                decoration: inputStyle("Email"),
              ),
              SizedBox(height: 10),

              // PASSWORD
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: inputStyle("Kata Sandi"),
              ),
              SizedBox(height: 10),

              // LUPA PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/forgot'),
                  child: Text(
                    "Lupa Kata Sandi?",
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text("Masuk"),
                ),
              ),
              SizedBox(height: 10),

              // REGISTER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum memiliki akun? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text(
                      "Daftar Sekarang",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[300],
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
    );
  }
}

// 🔥 HELPER
extension MapEncoding on Map<String, dynamic> {
  static Map<String, dynamic> fromUriEncoded(String encoded) {
    final decoded = Uri.splitQueryString(encoded);
    return decoded.map((k, v) => MapEntry(k, v));
  }

  static String toUriEncoded(Map<String, dynamic> map) {
    return map.entries
        .map((e) =>
            "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}")
        .join("&");
  }
}