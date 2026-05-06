import 'package:flutter/material.dart';
import '../models/transaksi_model.dart';

class TransaksiProvider extends ChangeNotifier {
  final List<TransaksiModel> _list = [
    // Data contoh awal
    const TransaksiModel(
      id: 'trx-001',
      mitra: 'CV Sumber Laut',
      produk: 'Cumi-cumi',
      jumlah: '45 kg',
      harga: '+Rp 2.250.000',
      tanggal: '8 Apr 2026',
      status: 'Selesai',
    ),
    const TransaksiModel(
      id: 'trx-002',
      mitra: 'UD Nelayan Rempang',
      produk: 'Ikan Kerapu',
      jumlah: '60 kg',
      harga: '+Rp 2.700.000',
      tanggal: '5 Apr 2026',
      status: 'Selesai',
    ),
  ];

  List<TransaksiModel> get list => List.unmodifiable(_list);

  void tambah(TransaksiModel item) {
    _list.insert(0, item);
    notifyListeners();
  }
}