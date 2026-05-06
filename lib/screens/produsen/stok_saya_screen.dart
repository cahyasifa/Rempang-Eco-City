import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/produksi_provider.dart';
import '../../models/produksi_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widget.dart';
import 'daftar_produksi_screen.dart';

class StokSayaScreen extends StatefulWidget {
  const StokSayaScreen({super.key});
  @override
  State<StokSayaScreen> createState() => _StokSayaScreenState();
}

class _StokSayaScreenState extends State<StokSayaScreen> {
  String _activeFilter = 'Semua';

  String _kategoriDari(String kategori) => kategori;

  Color _barColor(double ratio) {
    if (ratio >= 0.6) return AppColors.barGreen;
    if (ratio >= 0.3) return AppColors.barAmber;
    return AppColors.barRed;
  }

  BadgeType _badgeType(double ratio) {
    if (ratio >= 0.6) return BadgeType.green;
    if (ratio >= 0.3) return BadgeType.amber;
    return BadgeType.red;
  }

  String _rupiah(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    int c = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (c > 0 && c % 3 == 0) buf.write('.');
      buf.write(s[i]);
      c++;
    }
    return 'Rp ${buf.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProduksiProvider>();
    final semuaProduk = provider.list;

    // Gabungkan stok berdasarkan kategori + jenis
    final Map<String, _StokGabung> stokMap = {};
    for (final item in semuaProduk) {
      final key = '${item.kategori}__${item.jenisProduk}';
      if (stokMap.containsKey(key)) {
        stokMap[key] = stokMap[key]!.tambah(item.jumlahKg);
      } else {
        stokMap[key] = _StokGabung(
          kategori: item.kategori,
          jenis: item.jenisProduk,
          totalKg: item.jumlahKg,
          tanggal: item.tanggal,
        );
      }
    }

    final stokList = stokMap.values.toList();
    final totalSeluruh = stokList.fold(0.0, (s, e) => s + e.totalKg);
    final maxKg = stokList.isEmpty ? 1.0 : stokList.map((e) => e.totalKg).reduce((a, b) => a > b ? a : b);

    final filtered = _activeFilter == 'Semua'
        ? stokList
        : stokList.where((s) => s.kategori == _activeFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stok Saya',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
            Text('Total: ${totalSeluruh.toStringAsFixed(0)} kg tersedia',
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        toolbarHeight: 64,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFFE4E4E4)),
        ),
      ),
      body: semuaProduk.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 52, color: AppColors.textSecondary),
                  const SizedBox(height: 10),
                  const Text('Belum ada stok',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  const Text('Tambahkan lewat tab Produksi',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(children: [
                  MetricCard(
                    label: 'Total stok',
                    value: totalSeluruh.toStringAsFixed(0),
                    unit: 'kg',
                    accent: true,
                  ),
                  const SizedBox(width: 10),
                  MetricCard(
                    label: 'Jenis produk',
                    value: stokList.length.toString(),
                    unit: 'jenis',
                  ),
                ]),
                const SizedBox(height: 14),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    CategoryChip('Semua',
                        isActive: _activeFilter == 'Semua',
                        onTap: () => setState(() => _activeFilter = 'Semua')),
                    const SizedBox(width: 8),
                    CategoryChip('Ikan',
                        isActive: _activeFilter == 'Ikan',
                        onTap: () => setState(() => _activeFilter = 'Ikan')),
                    const SizedBox(width: 8),
                    CategoryChip('Udang',
                        isActive: _activeFilter == 'Udang',
                        onTap: () => setState(() => _activeFilter = 'Udang')),
                    const SizedBox(width: 8),
                    CategoryChip('Cumi',
                        isActive: _activeFilter == 'Cumi',
                        onTap: () => setState(() => _activeFilter = 'Cumi')),
                  ]),
                ),
                const SizedBox(height: 12),
                const AppDivider(),
                const SizedBox(height: 12),

                if (filtered.isEmpty)
                  const AppCard(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Tidak ada stok untuk kategori ini',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ),
                    ),
                  )
                else
                  ...filtered.map((s) {
                    final ratio = s.totalKg / maxKg;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(s.jenis,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                  const SizedBox(height: 2),
                                  Row(children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.chipDefault,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(s.kategori,
                                          style: const TextStyle(fontSize: 9, color: AppColors.chipDefaultText, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 6),
                                    Text('Update: ${s.tanggal}',
                                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                  ]),
                                ]),
                                StatusBadge(
                                  '${s.totalKg.toStringAsFixed(0)} kg',
                                  type: _badgeType(ratio),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 6,
                                backgroundColor: const Color(0xFFEAEAEA),
                                valueColor: AlwaysStoppedAnimation<Color>(_barColor(ratio)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 16),
              ],
            ),
    );
  }
}

class _StokGabung {
  final String kategori, jenis, tanggal;
  final double totalKg;
  const _StokGabung({required this.kategori, required this.jenis, required this.totalKg, required this.tanggal});
  _StokGabung tambah(double kg) => _StokGabung(kategori: kategori, jenis: jenis, totalKg: totalKg + kg, tanggal: tanggal);
}