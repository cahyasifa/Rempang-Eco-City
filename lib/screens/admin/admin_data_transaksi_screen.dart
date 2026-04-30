import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';

class AdminDataTransaksiScreen extends StatefulWidget {
  const AdminDataTransaksiScreen({super.key});
  @override
  State<AdminDataTransaksiScreen> createState() => _State();
}

class _State extends State<AdminDataTransaksiScreen> {
  String _filterStatus = 'Semua';

  static const _statusOptions = [
    'Semua', 'Menunggu Konfirmasi', 'Selesai', 'Ditolak'
  ];

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
    final list = admin.transaksiList.where((t) {
      if (_filterStatus == 'Semua') return true;
      return t.status == _filterStatus;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Filter Status: ',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              ..._statusOptions.map((s) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(s),
                      selected: _filterStatus == s,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                          color: _filterStatus == s
                              ? Colors.white
                              : AppColors.textDark),
                      onSelected: (_) =>
                          setState(() => _filterStatus = s),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
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
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                          AppColors.primary.withOpacity(0.08)),
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Tanggal')),
                        DataColumn(label: Text('Produsen')),
                        DataColumn(label: Text('Mitra Hilir')),
                        DataColumn(label: Text('Produk')),
                        DataColumn(label: Text('Jumlah')),
                        DataColumn(label: Text('Total')),
                        DataColumn(label: Text('Konfirmasi Mitra')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Aksi')),
                      ],
                      rows: list.map((t) {
                        return DataRow(cells: [
                          DataCell(Text(t.id)),
                          DataCell(Text(
                              '${t.tanggal.day}/${t.tanggal.month}/${t.tanggal.year}')),
                          DataCell(Text(t.produsenNama)),
                          DataCell(Text(t.mitraNama)),
                          DataCell(Text(t.produk)),
                          DataCell(Text('${t.jumlah} kg')),
                          DataCell(Text('Rp ${_fmt(t.totalHarga)}')),
                          DataCell(t.konfirmasiMitra == 'sudah_sampai'
                              ? const Row(children: [
                                  Icon(Icons.check_circle,
                                      color: AppColors.success, size: 16),
                                  SizedBox(width: 4),
                                  Text('Sudah Sampai',
                                      style: TextStyle(
                                          color: AppColors.success,
                                          fontSize: 12))
                                ])
                              : const Text('Menunggu',
                                  style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 12))),
                          DataCell(_StatusBadge(t.status)),
                          DataCell(
                            t.konfirmasiAdmin == null &&
                                    t.konfirmasiMitra == 'sudah_sampai'
                                ? Row(children: [
                                    IconButton(
                                      tooltip: 'Konfirmasi & Cairkan',
                                      icon: const Icon(Icons.check_circle,
                                          color: AppColors.success, size: 22),
                                      onPressed: () => _showKonfirmasi(
                                          context, admin, t, true),
                                    ),
                                    IconButton(
                                      tooltip: 'Tolak',
                                      icon: const Icon(Icons.cancel,
                                          color: AppColors.error, size: 22),
                                      onPressed: () => _showKonfirmasi(
                                          context, admin, t, false),
                                    ),
                                  ])
                                : const SizedBox(),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showKonfirmasi(BuildContext ctx, AdminProvider admin,
      TransaksiModel t, bool konfirmasi) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(konfirmasi
            ? 'Konfirmasi & Cairkan Dana'
            : 'Tolak Transaksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(konfirmasi
                ? 'Apakah barang sudah sampai dan Anda ingin mencairkan dana ke rekening produsen?'
                : 'Apakah Anda yakin ingin menolak transaksi ini?'),
            const SizedBox(height: 12),
            _infoRow('ID Transaksi', t.id),
            _infoRow('Produsen', t.produsenNama),
            _infoRow('Mitra Hilir', t.mitraNama),
            _infoRow('Total Dana',
                'Rp ${t.totalHarga.toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              admin.konfirmasiPembayaran(t.id, konfirmasi);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(konfirmasi
                      ? 'Dana berhasil dicairkan ke produsen!'
                      : 'Transaksi ditolak'),
                  backgroundColor:
                      konfirmasi ? AppColors.success : AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    konfirmasi ? AppColors.success : AppColors.error,
                foregroundColor: Colors.white),
            child: Text(konfirmasi ? 'Konfirmasi & Cairkan' : 'Tolak'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13)),
          Text(value, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);
  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (status) {
      case 'Selesai':
        bg = AppColors.success.withOpacity(0.15);
        fg = AppColors.success;
        break;
      case 'Ditolak':
        bg = AppColors.error.withOpacity(0.15);
        fg = AppColors.error;
        break;
      default:
        bg = AppColors.warning.withOpacity(0.15);
        fg = AppColors.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style: TextStyle(
              color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}