import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';

class AdminPembayaranScreen extends StatelessWidget {
  const AdminPembayaranScreen({super.key});

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

    // Hanya tampilkan yang menunggu konfirmasi admin
    final pending = admin.transaksiList
        .where((t) =>
            t.konfirmasiMitra == 'sudah_sampai' && t.konfirmasiAdmin == null)
        .toList();

    final selesai = admin.transaksiList
        .where((t) => t.konfirmasiAdmin == 'dikonfirmasi')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Pending Pembayaran ──
          Row(
            children: [
              const Text('Menunggu Pencairan Dana',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              if (pending.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('${pending.length}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (pending.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12)),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: AppColors.success, size: 48),
                    SizedBox(height: 8),
                    Text('Semua pembayaran sudah diproses!',
                        style: TextStyle(color: AppColors.textGrey)),
                  ],
                ),
              ),
            )
          else
            ...pending.map((t) => _PembayaranCard(
                  transaksi: t,
                  onKonfirmasi: (ok) {
                    if (ok) {
                      _showKonfirmasi(context, admin, t, true);
                    } else {
                      _showKonfirmasi(context, admin, t, false);
                    }
                  },
                  fmt: _fmt,
                )),
          const SizedBox(height: 32),
          // ── Riwayat Pembayaran Selesai ──
          const Text('Riwayat Pembayaran Selesai',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (selesai.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12)),
              child: const Center(
                child: Text('Belum ada pembayaran yang selesai.',
                    style: TextStyle(color: AppColors.textGrey)),
              ),
            )
          else
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
                        AppColors.success.withOpacity(0.08)),
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Tanggal')),
                      DataColumn(label: Text('Produsen')),
                      DataColumn(label: Text('Produk')),
                      DataColumn(label: Text('Dana Dicairkan')),
                    ],
                    rows: selesai.map((t) {
                      return DataRow(cells: [
                        DataCell(Text(t.id)),
                        DataCell(Text(
                            '${t.tanggal.day}/${t.tanggal.month}/${t.tanggal.year}')),
                        DataCell(Text(t.produsenNama)),
                        DataCell(Text(t.produk)),
                        DataCell(Text('Rp ${_fmt(t.totalHarga)}',
                            style: const TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold))),
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

  void _showKonfirmasi(BuildContext ctx, AdminProvider admin,
      TransaksiModel t, bool konfirmasi) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(
              konfirmasi ? Icons.account_balance_wallet : Icons.cancel,
              color: konfirmasi ? AppColors.success : AppColors.error,
            ),
            const SizedBox(width: 8),
            Text(konfirmasi ? 'Cairkan Dana' : 'Tolak Pembayaran'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(konfirmasi
                ? 'Dana akan dicairkan ke rekening produsen ${t.produsenNama}.'
                : 'Transaksi ini akan ditolak.'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  _row('Transaksi', t.id),
                  _row('Produsen', t.produsenNama),
                  _row('Mitra Hilir', t.mitraNama),
                  _row('Produk', t.produk),
                  _row('Total Dana', 'Rp ${t.totalHarga.toStringAsFixed(0)}'),
                ],
              ),
            ),
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
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                content: Text(konfirmasi
                    ? '✅ Dana Rp ${t.totalHarga.toStringAsFixed(0)} berhasil dicairkan!'
                    : '❌ Transaksi ditolak'),
                backgroundColor:
                    konfirmasi ? AppColors.success : AppColors.error,
              ));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    konfirmasi ? AppColors.success : AppColors.error,
                foregroundColor: Colors.white),
            child: Text(konfirmasi ? 'Cairkan Dana' : 'Tolak'),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textGrey, fontSize: 12)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PembayaranCard extends StatelessWidget {
  final TransaksiModel transaksi;
  final void Function(bool) onKonfirmasi;
  final String Function(double) fmt;

  const _PembayaranCard({
    required this.transaksi,
    required this.onKonfirmasi,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    final t = transaksi;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('Menunggu Konfirmasi Admin',
                    style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              Text(
                  '${t.tanggal.day}/${t.tanggal.month}/${t.tanggal.year}',
                  style: const TextStyle(
                      color: AppColors.textGrey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _info('ID Transaksi', t.id),
                    _info('Produsen', t.produsenNama),
                    _info('Mitra Hilir', t.mitraNama),
                    _info('Produk', t.produk),
                    _info('Jumlah', '${t.jumlah} kg'),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Total Dana',
                      style: TextStyle(
                          color: AppColors.textGrey, fontSize: 12)),
                  Text('Rp ${fmt(t.totalHarga)}',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.verified_user,
                          color: AppColors.success, size: 14),
                      const SizedBox(width: 4),
                      const Text('Mitra sudah konfirmasi barang sampai',
                          style: TextStyle(
                              color: AppColors.success,
                              fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => onKonfirmasi(false),
                icon: const Icon(Icons.cancel, size: 16),
                label: const Text('Tolak'),
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error)),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => onKonfirmasi(true),
                icon: const Icon(Icons.account_balance_wallet, size: 16),
                label: const Text('Konfirmasi & Cairkan Dana'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.textDark, fontSize: 13),
          children: [
            TextSpan(
                text: '$label: ',
                style: const TextStyle(color: AppColors.textGrey)),
            TextSpan(
                text: value,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}