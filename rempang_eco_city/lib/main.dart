import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Screens
import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/forgot_password.dart';
import 'screens/dashboard_produsen.dart';
import 'screens/dashboard_mitra.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🔥 THEME
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.blue,
      ),

      // 🔥 START APP
      home: SplashScreen(),

      // 🔥 ROUTES (LENGKAP)
      routes: {
        '/login': (_) => LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/forgot': (_) => ForgotPasswordScreen(),

        // 🔥 TAMBAHAN (biar bisa dipanggil dari mana aja)
        '/mitra': (_) => DashboardMitra(),
        '/produsen': (_) => DashboardProdusen(),
      },
    );
  }
}