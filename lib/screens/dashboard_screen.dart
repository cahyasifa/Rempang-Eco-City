import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/produksi_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProduksiProvider>();
    final totalKg = provider.list.fold(0.0, (s, e) => s + e.jumlahKg);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: buildAppBar('Dashboard', subtitle: 'Selamat datang, KUB Nelayan Rempang'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Aktivitas terbaru', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/daftar-produksi'),
                child: const Text('Lihat semua', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (provider.list.isEmpty)
            const AppCard(child: Center(child: Text('Belum ada aktivitas', style: TextStyle(color: AppColors.textSecondary, fontSize: 13))))
          else
            ...provider.list.take(3).map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Input produksi — ${item.produk}', style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(item.tanggal, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ]),
                        StatusBadge('+${item.jumlahKg.toStringAsFixed(0)} kg', type: BadgeType.green),
                      ],
                    ),
                  ),
                )),
          const SizedBox(height: 8),
          const AppDivider(),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/daftar-produksi'),
            icon: const Icon(Icons.list_alt_outlined, size: 16, color: AppColors.primary),
            label: const Text('Lihat Semua Data Produksi', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}