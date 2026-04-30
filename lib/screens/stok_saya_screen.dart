import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/produksi_provider.dart';
import '../models/produksi_model.dart';
import '../theme/app_colors.dart';
import '../widgets/shared_widgets.dart';

class StokSayaScreen extends StatefulWidget {
  const StokSayaScreen({super.key});
  @override
  State<StokSayaScreen> createState() => _StokSayaScreenState();
}

class _StokSayaScreenState extends State<StokSayaScreen> {
  String _activeFilter = 'Semua';

  // Ambil semua kategori unik dari data produksi
  List<String> _getKategori(List<ProduksiModel> list) {
    final Set<String> kategori = {};
    for (final item in list) {
      if (item.produk.toLowerCase().contains('kerapu') ||
          item.produk.toLowerCase().contains('kakap') ||
          item.produk.toLowerCase().contains('ikan')) {
        kategori.add('Ikan');
      } else if (item.produk.toLowerCase().contains('udang')) {
        kategori.add('Udang');
      } else if (item.produk.toLowerCase().contains('cumi')) {
        kategori.add('Cumi');
      } else if (item.produk.toLowerCase().contains('rajungan')) {
        kategori.add('Rajungan');
      } else {
        kategori.add('Lainnya');
      }
    }
    return kategori.toList();
  }

  // Tentukan kategori dari nama produk
  String _kategoriDari(String produk) {
    final p = produk.toLowerCase();
    if (p.contains('kerapu') || p.contains('kakap') || p.contains('ikan')) return 'Ikan';
    if (p.contains('udang')) return 'Udang';
    if (p.contains('cumi'))  return 'Cumi';
    if (p.contains('rajungan')) return 'Rajungan';
    return 'Lainnya';
  }

  // Warna bar berdasarkan rasio stok
  Color _barColor(double ratio) {
    if (ratio >= 0.6) return AppColors.barGreen;
    if (ratio >= 0.3) return AppColors.barAmber;
    return AppColors.barRed;
  }

  // Badge berdasarkan rasio stok
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

    // Gabungkan stok produk yang sama
    final Map<String, _StokGabung> stokMap = {};
    for (final item in semuaProduk) {
      if (stokMap.containsKey(item.produk)) {
        stokMap[item.produk] = stokMap[item.produk]!.tambah(item.jumlahKg);
      } else {
        stokMap[item.produk] = _StokGabung(
          produk: item.produk,
          totalKg: item.jumlahKg,
          tanggalTerakhir: item.tanggal,
          kategori: _kategoriDari(item.produk),
        );
      }
    }

    final stokList = stokMap.values.toList();
    final totalSeluruh = stokList.fold(0.0, (s, e) => s + e.totalKg);
    final maxKg = stokList.isEmpty ? 1.0 : stokList.map((e) => e.totalKg).reduce((a, b) => a > b ? a : b);

    // Filter berdasarkan kategori
    final filtered = _activeFilter == 'Semua'
        ? stokList
        : stokList.where((s) => s.kategori == _activeFilter).toList();

    final kategoriList = _getKategori(semuaProduk);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: buildAppBar(
        'Stok Saya',
        subtitle: 'Total: ${totalSeluruh.toStringAsFixed(0)} kg tersedia',
      ),
      body: semuaProduk.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      size: 52, color: AppColors.textSecondary),
                  const SizedBox(height: 10),
                  const Text('Belum ada stok',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  const Text('Tambahkan lewat menu Input Produksi',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/input-produksi'),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Input Produksi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Metrik total ─────────────────────────────────────────
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

                // ── Filter chip ──────────────────────────────────────────
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryChip('Semua',
                          isActive: _activeFilter == 'Semua',
                          onTap: () =>
                              setState(() => _activeFilter = 'Semua')),
                      ...kategoriList.map((k) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: CategoryChip(k,
                                isActive: _activeFilter == k,
                                onTap: () =>
                                    setState(() => _activeFilter = k)),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const AppDivider(),
                const SizedBox(height: 12),

                // ── List stok ────────────────────────────────────────────
                if (filtered.isEmpty)
                  const AppCard(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Tidak ada stok untuk kategori ini',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13)),
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
                            // Header
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(s.produk,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary)),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Update terakhir: ${s.tanggalTerakhir}',
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                StatusBadge(
                                  '${s.totalKg.toStringAsFixed(0)} kg',
                                  type: _badgeType(ratio),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 6,
                                backgroundColor: const Color(0xFFEAEAEA),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    _barColor(ratio)),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Info nilai
                            Row(children: [
                              const Icon(Icons.tag_outlined,
                                  size: 12,
                                  color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                'Kategori: ${s.kategori}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    );
                  }),

                const SizedBox(height: 4),
                const AppDivider(),
                const SizedBox(height: 16),
                PrimaryButton(
                  '+ Input Produksi Baru',
                  icon: Icons.add,
                  onTap: () =>
                      Navigator.pushNamed(context, '/input-produksi'),
                ),
              ],
            ),
    );
  }
}

// ─── Model stok gabungan ──────────────────────────────────────────────────────
class _StokGabung {
  final String produk;
  final double totalKg;
  final String tanggalTerakhir;
  final String kategori;

  const _StokGabung({
    required this.produk,
    required this.totalKg,
    required this.tanggalTerakhir,
    required this.kategori,
  });

  _StokGabung tambah(double kg) => _StokGabung(
        produk: produk,
        totalKg: totalKg + kg,
        tanggalTerakhir: tanggalTerakhir,
        kategori: kategori,
      );
}