import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaksi_provider.dart';
import '../../models/transaksi_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widget.dart';

class PermintaanMasukScreen extends StatefulWidget {
  const PermintaanMasukScreen({super.key});
  @override
  State<PermintaanMasukScreen> createState() => _PermintaanMasukScreenState();
}

class _PermintaanMasukScreenState extends State<PermintaanMasukScreen> {
  final List<_PermintaanItem> _items = [
    _PermintaanItem(
      id: 1,
      mitra: 'CV Mitra Bahari',
      produk: 'Ikan Kerapu',
      jumlah: '80 kg',
      harga: 'Rp 3.600.000',
      tanggal: '15 Apr 2026',
      status: 'Menunggu',
      bankTujuan: 'BRI',
      noRekening: '1234-5678-9012-3456',
      atasNama: 'KUB Nelayan Rempang',
      buktiPembayaran: 'assets/bukti_1.jpg',
    ),
    _PermintaanItem(
      id: 2,
      mitra: 'PT Seafood Nusantara',
      produk: 'Udang Vaname',
      jumlah: '50 kg',
      harga: 'Rp 4.250.000',
      tanggal: '14 Apr 2026',
      status: 'Menunggu',
      bankTujuan: 'BCA',
      noRekening: '9876-5432-1098-7654',
      atasNama: 'KUB Nelayan Rempang',
      buktiPembayaran: null,
    ),
    _PermintaanItem(
      id: 3,
      mitra: 'UD Bahari Jaya',
      produk: 'Kakap Merah',
      jumlah: '30 kg',
      harga: 'Rp 1.350.000',
      tanggal: '12 Apr 2026',
      status: 'Disetujui',
      bankTujuan: 'BRI',
      noRekening: '1234-5678-9012-3456',
      atasNama: 'KUB Nelayan Rempang',
      buktiPembayaran: 'assets/bukti_3.jpg',
    ),
  ];

  void _showPopupTolak(BuildContext context, _PermintaanItem item) {
    final alasanCtrl = TextEditingController();
    final List<String> alasanList = [
      'Stok tidak tersedia',
      'Harga tidak sesuai',
      'Lokasi pengiriman terlalu jauh',
      'Kualitas produk tidak memenuhi syarat',
      'Pembayaran tidak valid',
      'Lainnya',
    ];
    String? alasanDipilih;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setStateDialog) {
          return AlertDialog(
            backgroundColor: AppColors.bgCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            title: const Text(
              'Alasan Penolakan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Permintaan dari ${item.mitra} akan ditolak.\nPilih alasan penolakan:',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  ...alasanList.map((alasan) => GestureDetector(
                        onTap: () => setStateDialog(() => alasanDipilih = alasan),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: alasanDipilih == alasan ? AppColors.badgeRedBg : AppColors.bgPage,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: alasanDipilih == alasan ? AppColors.textDanger : AppColors.borderCard,
                              width: alasanDipilih == alasan ? 1.5 : 0.5,
                            ),
                          ),
                          child: Row(children: [
                            Icon(
                              alasanDipilih == alasan ? Icons.radio_button_checked : Icons.radio_button_off,
                              size: 16,
                              color: alasanDipilih == alasan ? AppColors.textDanger : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(alasan,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: alasanDipilih == alasan ? AppColors.textDanger : AppColors.textPrimary,
                                      fontWeight: alasanDipilih == alasan ? FontWeight.w500 : FontWeight.normal)),
                            ),
                          ]),
                        ),
                      )),
                  if (alasanDipilih == 'Lainnya') ...[
                    const SizedBox(height: 4),
                    TextField(
                      controller: alasanCtrl,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Tuliskan alasan lainnya...',
                        hintStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.bgPage,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderInput, width: 0.5)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderInput, width: 0.5)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.textDanger, width: 1.5)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: alasanDipilih == null
                    ? null
                    : () {
                        final alasanFinal = alasanDipilih == 'Lainnya' && alasanCtrl.text.isNotEmpty
                            ? alasanCtrl.text
                            : alasanDipilih!;
                        Navigator.pop(ctx);
                        _prosesTolak(item, alasanFinal);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: alasanDipilih == null ? AppColors.borderCard : AppColors.textDanger,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  disabledBackgroundColor: AppColors.borderCard,
                ),
                child: const Text('Konfirmasi Tolak'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _prosesTolak(_PermintaanItem item, String alasan) {
    setState(() {
      final idx = _items.indexWhere((e) => e.id == item.id);
      if (idx != -1) _items[idx] = _items[idx].copyWith(status: 'Ditolak', alasanTolak: alasan);
    });
    context.read<TransaksiProvider>().tambah(TransaksiModel(
      id: 'trx-${DateTime.now().millisecondsSinceEpoch}',
      mitra: item.mitra,
      produk: item.produk,
      jumlah: item.jumlah,
      harga: item.harga,
      tanggal: _hariIni(),
      status: 'Ditolak',
      alasanTolak: alasan,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permintaan ditolak & masuk ke riwayat'), backgroundColor: AppColors.textDanger),
    );
  }

  void _prosesSetujui(_PermintaanItem item) {
    setState(() {
      final idx = _items.indexWhere((e) => e.id == item.id);
      if (idx != -1) _items[idx] = _items[idx].copyWith(status: 'Disetujui');
    });
    context.read<TransaksiProvider>().tambah(TransaksiModel(
      id: 'trx-${DateTime.now().millisecondsSinceEpoch}',
      mitra: item.mitra,
      produk: item.produk,
      jumlah: item.jumlah,
      harga: item.harga,
      tanggal: _hariIni(),
      status: 'Selesai',
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permintaan disetujui & masuk ke riwayat'), backgroundColor: AppColors.primary),
    );
  }

  String _hariIni() {
    final now = DateTime.now();
    const bulan = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${now.day} ${bulan[now.month]} ${now.year}';
  }

  void _lihatPembayaran(BuildContext context, _PermintaanItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PembayaranSheet(
        item: item,
        onSetujui: () { Navigator.pop(context); _prosesSetujui(item); },
        onTolak: () { Navigator.pop(context); _showPopupTolak(context, item); },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menunggu = _items.where((e) => e.status == 'Menunggu').length;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      // ✅ AppBar standar, tidak pakai buildAppBar()
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFDFD),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Permintaan Masuk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
            Text('$menunggu permintaan menunggu',
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        toolbarHeight: 64,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: const Color(0xFFE4E4E4)),
        ),
      ),
      // ✅ TIDAK ADA bottomNavigationBar — sudah diurus ProdusenShell
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _items.map((item) {
          final isPending = item.status == 'Menunggu';
          final hasBukti  = item.buktiPembayaran != null;
          final isTolak   = item.status == 'Ditolak';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              opacity: isPending ? 1.0 : 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(item.mitra,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      ),
                      StatusBadge(
                        item.status,
                        type: item.status == 'Menunggu'
                            ? BadgeType.amber
                            : item.status == 'Disetujui'
                                ? BadgeType.green
                                : BadgeType.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    _DetailCell(label: 'Produk', value: item.produk),
                    _DetailCell(label: 'Jumlah', value: item.jumlah),
                  ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    _DetailCell(label: 'Total harga', value: item.harga, valueColor: AppColors.textSuccess),
                    _DetailCell(label: 'Tanggal', value: item.tanggal),
                  ]),
                  const SizedBox(height: 12),

                  if (isPending)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.chipDefault,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Transfer pembayaran ke:',
                            style: TextStyle(fontSize: 11, color: AppColors.chipDefaultText, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.account_balance_outlined, size: 13, color: AppColors.chipDefaultText),
                          const SizedBox(width: 5),
                          Text('${item.bankTujuan} — ${item.noRekening}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.chipDefaultText)),
                        ]),
                        const SizedBox(height: 2),
                        Text('a.n. ${item.atasNama}',
                            style: const TextStyle(fontSize: 11, color: AppColors.chipDefaultText)),
                      ]),
                    ),

                  if (isTolak && item.alasanTolak != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.badgeRedBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.textDanger.withOpacity(0.3), width: 0.5),
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Icon(Icons.info_outline, size: 14, color: AppColors.textDanger),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('Alasan ditolak:',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDanger)),
                            const SizedBox(height: 2),
                            Text(item.alasanTolak!,
                                style: const TextStyle(fontSize: 11, color: AppColors.textDanger)),
                          ]),
                        ),
                      ]),
                    ),
                  ],

                  if (isPending) const SizedBox(height: 10),
                  if (isPending)
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: hasBukti ? AppColors.badgeGreenBg : AppColors.badgeAmberBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          hasBukti ? Icons.check_circle_outline : Icons.hourglass_empty_outlined,
                          size: 14,
                          color: hasBukti ? AppColors.badgeGreenText : AppColors.badgeAmberText,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        hasBukti ? 'Bukti pembayaran sudah diupload' : 'Menunggu bukti pembayaran',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: hasBukti ? AppColors.badgeGreenText : AppColors.badgeAmberText,
                        ),
                      ),
                    ]),

                  if (isPending) const SizedBox(height: 10),
                  if (isPending && hasBukti)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _lihatPembayaran(context, item),
                        icon: const Icon(Icons.image_outlined, size: 15, color: AppColors.primary),
                        label: const Text('Lihat Bukti & Proses Pembayaran',
                            style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  if (isPending && !hasBukti)
                    Row(children: [
                      OutlineButton2('Tolak',
                          color: AppColors.textDanger,
                          onTap: () => _showPopupTolak(context, item)),
                      const SizedBox(width: 10),
                      OutlineButton2('Setujui',
                          color: AppColors.primary,
                          onTap: () => _prosesSetujui(item)),
                    ]),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Bottom Sheet ─────────────────────────────────────────────────────────────
class _PembayaranSheet extends StatefulWidget {
  final _PermintaanItem item;
  final VoidCallback onSetujui;
  final VoidCallback onTolak;
  const _PembayaranSheet({required this.item, required this.onSetujui, required this.onTolak});

  @override
  State<_PembayaranSheet> createState() => _PembayaranSheetState();
}

class _PembayaranSheetState extends State<_PembayaranSheet> {
  bool _zoomBukti = false;

  @override
  Widget build(BuildContext context) {
    final isPending = widget.item.status == 'Menunggu';
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 36, height: 4,
              decoration: BoxDecoration(color: AppColors.borderCard, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          const Text('Bukti Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(widget.item.mitra, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.bgPage,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderCard, width: 0.5)),
            child: Row(children: [
              Expanded(child: _SheetInfoCell(label: 'Produk', value: widget.item.produk)),
              Expanded(child: _SheetInfoCell(label: 'Jumlah', value: widget.item.jumlah)),
              Expanded(child: _SheetInfoCell(label: 'Total', value: widget.item.harga, highlight: true)),
            ]),
          ),
          const SizedBox(height: 14),
          const Text('Foto bukti transfer:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => _zoomBukti = !_zoomBukti),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: double.infinity,
              height: _zoomBukti ? 360 : 200,
              decoration: BoxDecoration(
                color: AppColors.bgPage,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderCard),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(fit: StackFit.expand, children: [
                Container(
                  color: const Color(0xFFF0F0F0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textSecondary),
                    const SizedBox(height: 8),
                    Text(widget.item.buktiPembayaran ?? '',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(_zoomBukti ? 'Tap untuk perkecil' : 'Tap untuk perbesar',
                        style: const TextStyle(fontSize: 10, color: AppColors.chipDefaultText)),
                  ]),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(6)),
                    child: Row(children: [
                      Icon(_zoomBukti ? Icons.zoom_out : Icons.zoom_in, size: 12, color: Colors.white),
                      const SizedBox(width: 3),
                      Text(_zoomBukti ? 'Perkecil' : 'Perbesar',
                          style: const TextStyle(fontSize: 10, color: Colors.white)),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 8),
          const Row(children: [
            Icon(Icons.access_time_outlined, size: 12, color: AppColors.textSecondary),
            SizedBox(width: 4),
            Text('Diupload oleh mitra: 15 Apr 2026, 10.32',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ]),
          const SizedBox(height: 20),
          if (isPending)
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onTolak,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textDanger,
                    side: const BorderSide(color: AppColors.textDanger),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Tolak', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onSetujui,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Setujui Pembayaran',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              ),
            ])
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.borderCard,
                  foregroundColor: AppColors.textSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Tutup', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ),
        ],
      ),
    );
  }
}

class _SheetInfoCell extends StatelessWidget {
  final String label, value;
  final bool highlight;
  const _SheetInfoCell({required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      const SizedBox(height: 2),
      Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: highlight ? AppColors.textSuccess : AppColors.textPrimary)),
    ]);
  }
}

class _DetailCell extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _DetailCell({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
            color: valueColor ?? AppColors.textPrimary)),
      ]),
    );
  }
}

class _PermintaanItem {
  final int id;
  final String mitra, produk, jumlah, harga, tanggal, status;
  final String bankTujuan, noRekening, atasNama;
  final String? buktiPembayaran;
  final String? alasanTolak;

  const _PermintaanItem({
    required this.id, required this.mitra, required this.produk,
    required this.jumlah, required this.harga, required this.tanggal,
    required this.status, required this.bankTujuan, required this.noRekening,
    required this.atasNama, this.buktiPembayaran, this.alasanTolak,
  });

  _PermintaanItem copyWith({String? status, String? alasanTolak}) => _PermintaanItem(
    id: id, mitra: mitra, produk: produk, jumlah: jumlah, harga: harga,
    tanggal: tanggal, status: status ?? this.status,
    bankTujuan: bankTujuan, noRekening: noRekening, atasNama: atasNama,
    buktiPembayaran: buktiPembayaran,
    alasanTolak: alasanTolak ?? this.alasanTolak,
  );
}