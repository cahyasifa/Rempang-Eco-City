import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_theme.dart';

class AdminLaporanScreen extends StatelessWidget {
  const AdminLaporanScreen({super.key});

  String _fmt(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();

    // Hitung produk terlaris
    final Map<String, double> produkMap = {};
    for (final t in admin.transaksiList) {
      produkMap[t.produk] = (produkMap[t.produk] ?? 0) + t.jumlah;
    }
    final produkEntries = produkMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalSelesai =
        admin.transaksiList.where((t) => t.status == 'Selesai').length;
    final totalMenunggu = admin.transaksiList
        .where((t) => t.status == 'Menunggu Konfirmasi')
        .length;
    final totalDitolak =
        admin.transaksiList.where((t) => t.status == 'Ditolak').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan Laporan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // Summary Cards
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _SummaryCard('Total Pendapatan',
                  'Rp ${_fmt(admin.totalPendapatan)}',
                  Icons.account_balance_wallet, AppColors.success),
              _SummaryCard('Transaksi Selesai', '$totalSelesai',
                  Icons.check_circle, AppColors.success),
              _SummaryCard('Transaksi Menunggu', '$totalMenunggu',
                  Icons.pending, AppColors.warning),
              _SummaryCard('Transaksi Ditolak', '$totalDitolak',
                  Icons.cancel, AppColors.error),
              _SummaryCard('Total Produsen', '${admin.totalProdusen}',
                  Icons.people, AppColors.primary),
              _SummaryCard('Total Mitra Hilir', '${admin.totalMitra}',
                  Icons.store, AppColors.info),
            ],
          ),
          const SizedBox(height: 32),
          // Status Bar Chart (manual)
          const Text('Distribusi Status Transaksi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]),
            child: Column(
              children: [
                _BarItem('Selesai', totalSelesai,
                    admin.totalTransaksi, AppColors.success),
                const SizedBox(height: 12),
                _BarItem('Menunggu', totalMenunggu,
                    admin.totalTransaksi, AppColors.warning),
                const SizedBox(height: 12),
                _BarItem('Ditolak', totalDitolak,
                    admin.totalTransaksi, AppColors.error),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Produk Terlaris
          const Text('Produk Terlaris',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                    AppColors.primary.withOpacity(0.08)),
                columns: const [
                  DataColumn(label: Text('Peringkat')),
                  DataColumn(label: Text('Produk')),
                  DataColumn(label: Text('Total Terjual (kg)')),
                ],
                rows: produkEntries.asMap().entries.map((e) {
                  final idx = e.key + 1;
                  final entry = e.value;
                  return DataRow(cells: [
                    DataCell(Text('$idx')),
                    DataCell(Text(entry.key)),
                    DataCell(Text('${entry.value} kg')),
                  ]);
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Riwayat Transaksi Lengkap
          const Text('Riwayat Semua Transaksi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                      AppColors.primary.withOpacity(0.08)),
                  columns: const [
                    DataColumn(label: Text('Tanggal')),
                    DataColumn(label: Text('Produsen')),
                    DataColumn(label: Text('Mitra')),
                    DataColumn(label: Text('Produk')),
                    DataColumn(label: Text('Jumlah')),
                    DataColumn(label: Text('Total')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: admin.transaksiList.map((t) {
                    return DataRow(cells: [
                      DataCell(Text(
                          '${t.tanggal.day}/${t.tanggal.month}/${t.tanggal.year}')),
                      DataCell(Text(t.produsenNama)),
                      DataCell(Text(t.mitraNama)),
                      DataCell(Text(t.produk)),
                      DataCell(Text('${t.jumlah} kg')),
                      DataCell(Text('Rp ${_fmt(t.totalHarga)}')),
                      DataCell(Text(t.status,
                          style: TextStyle(
                            color: t.status == 'Selesai'
                                ? AppColors.success
                                : t.status == 'Ditolak'
                                    ? AppColors.error
                                    : AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ))),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _SummaryCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ]),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 11)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final String label;
  final int value, total;
  final Color color;
  const _BarItem(this.label, this.value, this.total, this.color);

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : value / total;
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label)),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
            width: 60,
            child: Text('$value (${(pct * 100).toStringAsFixed(0)}%)',
                style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}