import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Jika kamu sudah buat role_switch.dart, importnya seperti ini:
import 'role_switch.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String selectedRole = "mitra";
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

Future<void> register() async {
  final prefs = await SharedPreferences.getInstance();

  List<String> users = prefs.getStringList('users') ?? [];

  Map<String, String> newUser = {
    "name": nameController.text,
    "email": emailController.text.trim(),
    "password": passwordController.text.trim(),
    "role": selectedRole,
  };

  users.add(MapEncoding.toUriEncoded(newUser));

  await prefs.setStringList('users', users);

  showMessage("Register berhasil");
  Navigator.pop(context);
}

  void showMessage(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5EBDD),
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Daftar Sekarang", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              RoleSwitch(
                role: selectedRole,
                onChanged: (value) => setState(() => selectedRole = value),
              ),
              SizedBox(height: 10),
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Nama")),
              TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
              TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Kata Sandi")),
              SizedBox(height: 20),
              ElevatedButton(onPressed: register, child: Text("Daftar"))
            ],
          ),
        ),
      ),
    );
  }
}

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