import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';

class AdminDataProduksiScreen extends StatefulWidget {
  const AdminDataProduksiScreen({super.key});
  @override
  State<AdminDataProduksiScreen> createState() => _State();
}

class _State extends State<AdminDataProduksiScreen> {
  String _search = '';

  static const _statusList = ['Tersedia', 'Habis', 'Dalam Proses'];

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
    final list = admin.produksiList
        .where((p) => p.produk.toLowerCase().contains(_search.toLowerCase()) ||
            p.produsenNama.toLowerCase().contains(_search.toLowerCase()))
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
                    hintText: 'Cari produksi...',
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
                label: const Text('Tambah Data'),
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
                        DataColumn(label: Text('Tanggal')),
                        DataColumn(label: Text('Produsen')),
                        DataColumn(label: Text('Produk')),
                        DataColumn(label: Text('Jumlah (kg)')),
                        DataColumn(label: Text('Harga/kg')),
                        DataColumn(label: Text('Total')),
                        DataColumn(label: Text('Status Stok')),
                        DataColumn(label: Text('Aksi')),
                      ],
                      rows: list.map((p) {
                        return DataRow(cells: [
                          DataCell(Text(
                              '${p.tanggal.day}/${p.tanggal.month}/${p.tanggal.year}')),
                          DataCell(Text(p.produsenNama)),
                          DataCell(Text(p.produk)),
                          DataCell(Text('${p.jumlahKg} kg')),
                          DataCell(Text('Rp ${_fmt(p.hargaPerKg)}')),
                          DataCell(Text('Rp ${_fmt(p.totalHarga)}')),
                          DataCell(_StokChip(p.statusStok)),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete,
                                color: AppColors.error, size: 20),
                            onPressed: () {
                              admin.hapusProduksi(p.id);
                            },
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

  void _showForm(BuildContext ctx) {
    final admin = ctx.read<AdminProvider>();
    final produkCtrl = TextEditingController();
    final jumlahCtrl = TextEditingController();
    final hargaCtrl = TextEditingController();
    String? selectedProdusenId;
    String status = _statusList.first;
    DateTime tanggal = DateTime.now();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: ctx,
      builder: (_) => StatefulBuilder(
        builder: (ctx2, setS) => AlertDialog(
          title: const Text('Tambah Data Produksi'),
          content: SizedBox(
            width: 480,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedProdusenId,
                      decoration: const InputDecoration(
                          labelText: 'Produsen',
                          border: OutlineInputBorder()),
                      validator: (v) =>
                          v == null ? 'Pilih produsen' : null,
                      items: admin.produsenList
                          .map((p) => DropdownMenuItem(
                              value: p.id, child: Text(p.nama)))
                          .toList(),
                      onChanged: (v) =>
                          setS(() => selectedProdusenId = v),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: produkCtrl,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                      decoration: const InputDecoration(
                          labelText: 'Nama Produk',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: jumlahCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                      decoration: const InputDecoration(
                          labelText: 'Jumlah (kg)',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: hargaCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                      decoration: const InputDecoration(
                          labelText: 'Harga per kg (Rp)',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(
                          labelText: 'Status Stok',
                          border: OutlineInputBorder()),
                      items: _statusList
                          .map((s) =>
                              DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setS(() => status = v!),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx2,
                          initialDate: tanggal,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) setS(() => tanggal = picked);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            labelText: 'Tanggal',
                            border: OutlineInputBorder()),
                        child: Text(
                            '${tanggal.day}/${tanggal.month}/${tanggal.year}'),
                      ),
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
                final produsen = admin.produsenList
                    .firstWhere((p) => p.id == selectedProdusenId);
                admin.tambahProduksi(ProduksiModel(
                  id: 'PR${DateTime.now().millisecondsSinceEpoch}',
                  produsenId: produsen.id,
                  produsenNama: produsen.nama,
                  produk: produkCtrl.text,
                  jumlahKg: double.tryParse(jumlahCtrl.text) ?? 0,
                  hargaPerKg: double.tryParse(hargaCtrl.text) ?? 0,
                  statusStok: status,
                  tanggal: tanggal,
                ));
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StokChip extends StatelessWidget {
  final String status;
  const _StokChip(this.status);
  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (status) {
      case 'Tersedia':
        bg = AppColors.success.withOpacity(0.15);
        fg = AppColors.success;
        break;
      case 'Habis':
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