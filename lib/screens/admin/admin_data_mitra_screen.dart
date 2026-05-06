import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_theme.dart';

class AdminDataMitraScreen extends StatefulWidget {
  const AdminDataMitraScreen({super.key});
  @override
  State<AdminDataMitraScreen> createState() => _State();
}

class _State extends State<AdminDataMitraScreen> {
  String _search = '';

  static const _jenisUsahaList = [
    'Distributor', 'Retailer', 'Restoran', 'Eksportir', 'Supermarket',
  ];

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final list = admin.mitraList
        .where((m) =>
            m.namaUsaha.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'Cari mitra hilir...',
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
                label: const Text('Tambah Mitra'),
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
                        DataColumn(label: Text('Nama Usaha')),
                        DataColumn(label: Text('Kontak')),
                        DataColumn(label: Text('Alamat')),
                        DataColumn(label: Text('Jenis Usaha')),
                        DataColumn(label: Text('Aksi')),
                      ],
                      rows: list.map((m) {
                        return DataRow(cells: [
                          DataCell(Text(m.id)),
                          DataCell(Text(m.namaUsaha)),
                          DataCell(Text(m.kontak)),
                          DataCell(SizedBox(
                              width: 160,
                              child: Text(m.alamat,
                                  overflow: TextOverflow.ellipsis))),
                          DataCell(Text(m.jenisUsaha)),
                          DataCell(Row(children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: AppColors.info, size: 20),
                              onPressed: () => _showForm(context, m),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: AppColors.error, size: 20),
                              onPressed: () =>
                                  _confirmDelete(context, admin, m.id),
                            ),
                          ])),
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

  void _confirmDelete(BuildContext ctx, AdminProvider admin, String id) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Mitra'),
        content: const Text('Yakin ingin menghapus data mitra ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              admin.hapusMitra(id);
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

  void _showForm(BuildContext ctx, [MitraModel? existing]) {
    final namaCtrl = TextEditingController(text: existing?.namaUsaha);
    final kontakCtrl = TextEditingController(text: existing?.kontak);
    final alamatCtrl = TextEditingController(text: existing?.alamat);
    String jenis = existing?.jenisUsaha ?? _jenisUsahaList.first;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: ctx,
      builder: (_) => StatefulBuilder(
        builder: (ctx2, setS) => AlertDialog(
          title: Text(existing == null ? 'Tambah Mitra Hilir' : 'Edit Mitra Hilir'),
          content: SizedBox(
            width: 440,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _field('Nama Usaha', namaCtrl),
                  const SizedBox(height: 12),
                  _field('Kontak', kontakCtrl,
                      keyboard: TextInputType.phone),
                  const SizedBox(height: 12),
                  _field('Alamat', alamatCtrl, maxLines: 2),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: jenis,
                    decoration: const InputDecoration(
                        labelText: 'Jenis Usaha',
                        border: OutlineInputBorder()),
                    items: _jenisUsahaList
                        .map((j) =>
                            DropdownMenuItem(value: j, child: Text(j)))
                        .toList(),
                    onChanged: (v) => setS(() => jenis = v!),
                  ),
                ],
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
                  admin.tambahMitra(MitraModel(
                    id: 'M${DateTime.now().millisecondsSinceEpoch}',
                    namaUsaha: namaCtrl.text,
                    kontak: kontakCtrl.text,
                    alamat: alamatCtrl.text,
                    jenisUsaha: jenis,
                  ));
                } else {
                  existing.namaUsaha = namaCtrl.text;
                  existing.kontak = kontakCtrl.text;
                  existing.alamat = alamatCtrl.text;
                  existing.jenisUsaha = jenis;
                  admin.updateMitra(existing);
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
      {TextInputType? keyboard, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: (v) => (v == null || v.isEmpty) ? '$label wajib diisi' : null,
      decoration: InputDecoration(
          labelText: label, border: const OutlineInputBorder()),
    );
  }
}