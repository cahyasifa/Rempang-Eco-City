import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final newPassController = TextEditingController();

  Future<void> resetPassword() async {
    final prefs = await SharedPreferences.getInstance();

    String? savedEmail = prefs.getString('email');

    if (emailController.text.trim() != savedEmail) {
      showMessage("Email tidak ditemukan");
      return;
    }

    if (newPassController.text.length < 6) {
      showMessage("Password minimal 6 karakter");
      return;
    }

    await prefs.setString('password', newPassController.text.trim());

    showMessage("Password berhasil diubah");

    Navigator.pop(context);
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EBDD),
      appBar: AppBar(title: Text("Lupa Password")),
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Reset Password",
                  style: TextStyle(fontWeight: FontWeight.bold)),

              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),

              TextField(
                controller: newPassController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password Baru"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: resetPassword,
                child: Text("Simpan"),
              )
            ],
          ),
        ),
      ),
    );
  }
}