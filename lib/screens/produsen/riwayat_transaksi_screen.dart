import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaksi_provider.dart'; 
import '../../theme/app_theme.dart';
import '../../widgets/shared_widget.dart';

class RiwayatTransaksiScreen extends StatefulWidget {
  const RiwayatTransaksiScreen({super.key});
  @override
  State<RiwayatTransaksiScreen> createState() => _RiwayatTransaksiScreenState();
}

class _RiwayatTransaksiScreenState extends State<RiwayatTransaksiScreen> {
  String _filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransaksiProvider>();
    final filtered = _filter == 'Semua'
        ? provider.list
        : provider.list.where((t) => t.status == _filter).toList();

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Riwayat Transaksi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
            Text('${provider.list.length} total transaksi',
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              CategoryChip('Semua',   isActive: _filter == 'Semua',   onTap: () => setState(() => _filter = 'Semua')),
              const SizedBox(width: 8),
              CategoryChip('Selesai', isActive: _filter == 'Selesai', onTap: () => setState(() => _filter = 'Selesai')),
              const SizedBox(width: 8),
              CategoryChip('Ditolak', isActive: _filter == 'Ditolak', onTap: () => setState(() => _filter = 'Ditolak')),
            ]),
          ),
          const SizedBox(height: 12),
          const AppDivider(),
          const SizedBox(height: 12),

          if (filtered.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(children: const [
                  Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textSecondary),
                  SizedBox(height: 8),
                  Text('Belum ada riwayat transaksi',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ]),
              ),
            )
          else
            ...filtered.map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(t.mitra,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text('${t.produk} · ${t.jumlah}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          Text(t.tanggal,
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ]),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text(t.harga,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: t.status == 'Selesai' ? AppColors.textSuccess : AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          StatusBadge(t.status,
                              type: t.status == 'Selesai' ? BadgeType.green : BadgeType.red),
                        ]),
                      ],
                    ),
                    if (t.status == 'Ditolak' && t.alasanTolak != null) ...[
                      const SizedBox(height: 10),
                      const AppDivider(),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.badgeRedBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline, size: 13, color: AppColors.textDanger),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Alasan ditolak:',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textDanger)),
                                  const SizedBox(height: 2),
                                  Text(t.alasanTolak!,
                                      style: const TextStyle(fontSize: 11, color: AppColors.textDanger)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            )),
        ],
      ),
    );
  }
}