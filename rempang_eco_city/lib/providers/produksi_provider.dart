import 'package:flutter/material.dart';
import '../models/produksi_model.dart';

class ProduksiProvider extends ChangeNotifier {
  final List<ProduksiModel> _list = [
    ProduksiModel(
      id: '001',
      tanggal: '16 Apr 2026',
      kategori: 'Ikan',
      jenisProduk: 'Kerapu',
      jumlahKg: 120,
      hargaPerKg: 45000,
      lokasiTangkap: 'Perairan Rempang Barat',
      catatan: 'Kualitas grade A',
    ),
    ProduksiModel(
      id: '002',
      tanggal: '14 Apr 2026',
      kategori: 'Udang',
      jenisProduk: 'Vaname',
      jumlahKg: 80,
      hargaPerKg: 55000,
      lokasiTangkap: 'Teluk Rempang',
      catatan: '',
    ),
    ProduksiModel(
      id: '003',
      tanggal: '12 Apr 2026',
      kategori: 'Ikan',
      jenisProduk: 'Kakap Merah',
      jumlahKg: 60,
      hargaPerKg: 40000,
      lokasiTangkap: 'Perairan Galang',
      catatan: 'Ukuran sedang-besar',
    ),
    ProduksiModel(
      id: '004',
      tanggal: '10 Apr 2026',
      kategori: 'Cumi',
      jenisProduk: 'Cumi Putih',
      jumlahKg: 50,
      hargaPerKg: 50000,
      lokasiTangkap: 'Perairan Rempang',
      catatan: '',
    ),
  ];

  List<ProduksiModel> get list => List.unmodifiable(_list);

  void tambah(ProduksiModel item) {
    _list.insert(0, item);
    notifyListeners();
  }

  void hapus(String id) {
    _list.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}