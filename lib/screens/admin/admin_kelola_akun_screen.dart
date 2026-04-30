import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';

class AdminKelolaAkunScreen extends StatefulWidget {
  const AdminKelolaAkunScreen({super.key});
  @override
  State<AdminKelolaAkunScreen> createState() => _State();
}

class _State extends State<AdminKelolaAkunScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tab,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textGrey,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'Akun Produsen'),
                Tab(text: 'Akun Mitra Hilir'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                // ── Produsen Accounts ──
                _AkunTable(
                  headers: const ['ID', 'Nama', 'Email', 'Status', 'Aksi'],
                  rows: admin.produsenList.map((p) {
                    return [
                      p.id,
                      p.nama,
                      p.email ?? '-',
                      p.aktif ? 'Aktif' : 'Nonaktif',
                      p.id, // used for action
                    ];
                  }).toList(),
                  onToggle: (id) => admin.toggleStatusProdusen(id),
                  onResetPass: (id) => _resetPassword(context, id),
                ),
                // ── Mitra Accounts ──
                _MitraAkunTable(admin: admin),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _resetPassword(BuildContext ctx, String id) {
    final passCtrl = TextEditingController();
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Reset Password'),
        content: SizedBox(
          width: 360,
          child: TextField(
            controller: passCtrl,
            obscureText: true,
            decoration: const InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder()),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              // TODO: update password logic
              Navigator.pop(ctx);
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                    content: Text('Password berhasil direset!'),
                    backgroundColor: AppColors.success),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _AkunTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final void Function(String id) onToggle;
  final void Function(String id) onResetPass;

  const _AkunTable({
    required this.headers,
    required this.rows,
    required this.onToggle,
    required this.onResetPass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              columns:
                  headers.map((h) => DataColumn(label: Text(h))).toList(),
              rows: rows.map((r) {
                final id = r[4];
                final aktif = r[3] == 'Aktif';
                return DataRow(cells: [
                  DataCell(Text(r[0])),
                  DataCell(Text(r[1])),
                  DataCell(Text(r[2])),
                  DataCell(Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: aktif
                            ? AppColors.success.withOpacity(0.15)
                            : AppColors.error.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(r[3],
                        style: TextStyle(
                            color: aktif
                                ? AppColors.success
                                : AppColors.error,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  )),
                  DataCell(Row(children: [
                    TextButton.icon(
                      icon: Icon(
                          aktif
                              ? Icons.block
                              : Icons.check_circle,
                          size: 16),
                      label: Text(aktif ? 'Nonaktifkan' : 'Aktifkan',
                          style: const TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                          foregroundColor:
                              aktif ? AppColors.error : AppColors.success),
                      onPressed: () => onToggle(id),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.lock_reset, size: 16),
                      label: const Text('Reset Pass',
                          style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                          foregroundColor: AppColors.info),
                      onPressed: () => onResetPass(id),
                    ),
                  ])),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _MitraAkunTable extends StatelessWidget {
  final AdminProvider admin;
  const _MitraAkunTable({required this.admin});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
                AppColors.primary.withOpacity(0.08)),
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Nama Usaha')),
              DataColumn(label: Text('Kontak')),
              DataColumn(label: Text('Jenis')),
            ],
            rows: admin.mitraList.map((m) {
              return DataRow(cells: [
                DataCell(Text(m.id)),
                DataCell(Text(m.namaUsaha)),
                DataCell(Text(m.kontak)),
                DataCell(Text(m.jenisUsaha)),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}