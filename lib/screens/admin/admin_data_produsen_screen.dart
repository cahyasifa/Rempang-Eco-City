import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';

class AdminDataProdusenScreen extends StatefulWidget {
  const AdminDataProdusenScreen({super.key});
  @override
  State<AdminDataProdusenScreen> createState() => _State();
}

class _State extends State<AdminDataProdusenScreen> {
  String _search = '';

  static const _jenisUsahaList = [
    'Pertanian', 'Perkebunan', 'Peternakan', 'Perikanan', 'Pengolahan',
  ];

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final list = admin.produsenList
        .where((p) => p.nama.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'Cari produsen...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    filled: true,
                    fillColor: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _showForm(context),
                icon: const Icon(Icons.add),
                label: const Text('Tambah Produsen'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14)),
              ),
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
                ],
              ),
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
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('No. HP')),
                        DataColumn(label: Text('Alamat')),
                        DataColumn(label: Text('Jenis Usaha')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Aksi')),
                      ],
                      rows: list.map((p) {
                        return DataRow(cells: [
                          DataCell(Text(p.id)),
                          DataCell(Text(p.nama)),
                          DataCell(Text(p.noHp)),
                          DataCell(SizedBox(
                              width: 160,
                              child: Text(p.alamat,
                                  overflow: TextOverflow.ellipsis))),
                          DataCell(Text(p.jenisUsaha)),
                          DataCell(
                            Switch(
                              value: p.aktif,
                              activeColor: AppColors.success,
                              onChanged: (_) =>
                                  admin.toggleStatusProdusen(p.id),
                            ),
                          ),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: AppColors.info, size: 20),
                                onPressed: () => _showForm(context, p),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: AppColors.error, size: 20),
                                onPressed: () =>
                                    _confirmDelete(context, admin, p.id),
                              ),
                            ],
                          )),
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

  void _confirmDelete(
      BuildContext ctx, AdminProvider admin, String id) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Produsen'),
        content: const Text('Yakin ingin menghapus data produsen ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              admin.hapusProdusen(id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showForm(BuildContext ctx, [ProdusenModel? existing]) {
    final namaCtrl = TextEditingController(text: existing?.nama);
    final hpCtrl = TextEditingController(text: existing?.noHp);
    final alamatCtrl = TextEditingController(text: existing?.alamat);
    final emailCtrl = TextEditingController(text: existing?.email);
    final passCtrl = TextEditingController();
    String jenis = existing?.jenisUsaha ?? _jenisUsahaList.first;
    bool aktif = existing?.aktif ?? true;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: ctx,
      builder: (_) => StatefulBuilder(
        builder: (ctx2, setS) => AlertDialog(
          title: Text(existing == null ? 'Tambah Produsen' : 'Edit Produsen'),
          content: SizedBox(
            width: 480,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _field('Nama Lengkap', namaCtrl),
                    const SizedBox(height: 12),
                    _field('No. HP', hpCtrl, keyboard: TextInputType.phone),
                    const SizedBox(height: 12),
                    _field('Alamat', alamatCtrl, maxLines: 2),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: jenis,
                      decoration: const InputDecoration(
                          labelText: 'Jenis Usaha',
                          border: OutlineInputBorder()),
                      items: _jenisUsahaList
                          .map((j) => DropdownMenuItem(value: j, child: Text(j)))
                          .toList(),
                      onChanged: (v) => setS(() => jenis = v!),
                    ),
                    const SizedBox(height: 12),
                    _field('Email (Akun)',  emailCtrl,
                        keyboard: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    if (existing == null)
                      _field('Password', passCtrl, obscure: true),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Status Aktif'),
                        const Spacer(),
                        Switch(
                          value: aktif,
                          activeColor: AppColors.success,
                          onChanged: (v) => setS(() => aktif = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                final admin = ctx.read<AdminProvider>();
                if (existing == null) {
                  admin.tambahProdusen(ProdusenModel(
                    id: 'P${DateTime.now().millisecondsSinceEpoch}',
                    nama: namaCtrl.text,
                    noHp: hpCtrl.text,
                    alamat: alamatCtrl.text,
                    jenisUsaha: jenis,
                    aktif: aktif,
                    email: emailCtrl.text,
                    password: passCtrl.text,
                  ));
                } else {
                  existing.nama = namaCtrl.text;
                  existing.noHp = hpCtrl.text;
                  existing.alamat = alamatCtrl.text;
                  existing.jenisUsaha = jenis;
                  existing.aktif = aktif;
                  existing.email = emailCtrl.text;
                  admin.updateProdusen(existing);
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white),
              child: Text(existing == null ? 'Simpan' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType? keyboard, int maxLines = 1, bool obscure = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      obscureText: obscure,
      validator: (v) => (v == null || v.isEmpty) ? '$label wajib diisi' : null,
      decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder()),
    );
  }
}