import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/produksi_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProduksiProvider>();
    final totalKg = provider.list.fold(0.0, (s, e) => s + e.jumlahKg);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
            Text('Selamat datang, KUB Nelayan Rempang', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        toolbarHeight: 64,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFFE4E4E4)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            MetricCard(label: 'Total produksi', value: totalKg.toStringAsFixed(0), unit: 'kg', accent: true),
            const SizedBox(width: 10),
            const MetricCard(label: 'Stok tersedia', value: '380', unit: 'kg'),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            const MetricCard(label: 'Permintaan masuk', value: '3', valueColor: AppColors.badgeBlueText),
            const SizedBox(width: 10),
            const MetricCard(label: 'Pendapatan bulan ini', value: 'Rp 4,2jt'),
          ]),
          const SizedBox(height: 16),
          const AppDivider(),
          const SizedBox(height: 12),
          const Text('Aktivitas terbaru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          if (provider.list.isEmpty)
            const AppCard(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Belum ada aktivitas', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ),
              ),
            )
          else
            ...provider.list.take(3).map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${item.kategori} — ${item.jenisProduk}', style: const TextStyle(fontSize: 13)),
                      Text(item.tanggal, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ]),
                    StatusBadge('+${item.jumlahKg.toStringAsFixed(0)} kg', type: BadgeType.green),
                  ],
                ),
              ),
            )),
        ],
      ),
      // ✅ TIDAK ADA bottomNavigationBar — sudah diurus ProdusenShell
    );
  }
}