import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/produksi_provider.dart';
import 'providers/transaksi_provider.dart';
import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/dashboard_screen.dart';
import 'screens/stok_saya_screen.dart';
import 'screens/permintaan_masuk_screen.dart';
import 'screens/riwayat_transaksi_screen.dart';
import 'screens/daftar_produksi_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/app_colors.dart';
import 'providers/admin_provider.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('users', [

    Uri(queryParameters: {
    'nama':     'Admin Rempang',
    'email':    'admin@rempang.id',
    'password': 'admin123',
    'role':     'admin',
  }).query,
  
    Uri(queryParameters: {
      'nama':     'KUB Nelayan Rempang',
      'email':    'kub.nelayan@rempang.id',
      'password': 'produsen123',
      'role':     'produsen',
    }).query,
    Uri(queryParameters: {
      'nama':     'KUB Bahari Galang',
      'email':    'kub.bahari@rempang.id',
      'password': 'produsen123',
      'role':     'produsen',
    }).query,
    Uri(queryParameters: {
      'nama':     'UD Hasil Laut',
      'email':    'ud.hasillaut@rempang.id',
      'password': 'produsen123',
      'role':     'produsen',
    }).query,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProduksiProvider()),
        ChangeNotifierProvider(create: (_) => TransaksiProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: const RempangApp(),
    ),
  );
}

class RempangApp extends StatelessWidget {
  const RempangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rempang Eco City',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgPage,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.appBar,
          foregroundColor: AppColors.appBarText,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login':    (_) => const LoginScreen(),
        '/produsen': (_) => const MainShell(),
        '/admin': (context) => const AdminDashboardScreen(),
        // ← HAPUS route /daftar-produksi dan /input-produksi
        // semua navigasi pakai MaterialPageRoute langsung
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;

  final _screens = const [
    DashboardScreen(),
    DaftarProduksiScreen(), // ← tab Produksi = Daftar, bukan Form
    StokSayaScreen(),
    PermintaanMasukScreen(),
    RiwayatTransaksiScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.bgCard,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined),    activeIcon: Icon(Icons.dashboard),    label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_outlined),     activeIcon: Icon(Icons.inventory),    label: 'Produksi'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined),   activeIcon: Icon(Icons.inventory_2),  label: 'Stok'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined),         activeIcon: Icon(Icons.inbox),        label: 'Permintaan'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined),  activeIcon: Icon(Icons.receipt_long), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline),         activeIcon: Icon(Icons.person),       label: 'Profil'),
        ],
      ),
    );
  }
}