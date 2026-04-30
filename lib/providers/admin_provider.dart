import 'package:flutter/material.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class ProdusenModel {
  String id, nama, noHp, alamat, jenisUsaha;
  bool aktif;
  String? email, password;

  ProdusenModel({
    required this.id,
    required this.nama,
    required this.noHp,
    required this.alamat,
    required this.jenisUsaha,
    this.aktif = true,
    this.email,
    this.password,
  });
}

class MitraModel {
  String id, namaUsaha, kontak, alamat, jenisUsaha;

  MitraModel({
    required this.id,
    required this.namaUsaha,
    required this.kontak,
    required this.alamat,
    required this.jenisUsaha,
  });
}

class ProduksiModel {
  String id, produsenId, produsenNama, produk, statusStok;
  DateTime tanggal;
  double jumlahKg, hargaPerKg;

  ProduksiModel({
    required this.id,
    required this.produsenId,
    required this.produsenNama,
    required this.produk,
    required this.jumlahKg,
    required this.hargaPerKg,
    required this.statusStok,
    required this.tanggal,
  });

  double get totalHarga => jumlahKg * hargaPerKg;
}

class TransaksiModel {
  String id, produsenId, produsenNama, mitraId, mitraNama, produk, status;
  DateTime tanggal;
  double jumlah, totalHarga;
  String? konfirmasiMitra; // 'sudah_sampai' | null
  String? konfirmasiAdmin; // 'dikonfirmasi' | 'ditolak' | null

  TransaksiModel({
    required this.id,
    required this.produsenId,
    required this.produsenNama,
    required this.mitraId,
    required this.mitraNama,
    required this.produk,
    required this.jumlah,
    required this.totalHarga,
    required this.status,
    required this.tanggal,
    this.konfirmasiMitra,
    this.konfirmasiAdmin,
  });
}

// ─── Provider ─────────────────────────────────────────────────────────────────

class AdminProvider extends ChangeNotifier {
  // ── Produsen ──
  final List<ProdusenModel> _produsenList = [
    ProdusenModel(
      id: 'P001',
      nama: 'Budi Santoso',
      noHp: '081234567890',
      alamat: 'Jl. Rempang No. 1, Batam',
      jenisUsaha: 'Pertanian',
      aktif: true,
      email: 'budi@rempang.id',
    ),
    ProdusenModel(
      id: 'P002',
      nama: 'Siti Aminah',
      noHp: '082345678901',
      alamat: 'Jl. Galang No. 5, Batam',
      jenisUsaha: 'Perkebunan',
      aktif: false,
      email: 'siti@rempang.id',
    ),
  ];

  List<ProdusenModel> get produsenList => List.unmodifiable(_produsenList);

  void tambahProdusen(ProdusenModel p) {
    _produsenList.add(p);
    notifyListeners();
  }

  void updateProdusen(ProdusenModel p) {
    final i = _produsenList.indexWhere((x) => x.id == p.id);
    if (i != -1) {
      _produsenList[i] = p;
      notifyListeners();
    }
  }

  void toggleStatusProdusen(String id) {
    final i = _produsenList.indexWhere((x) => x.id == id);
    if (i != -1) {
      _produsenList[i].aktif = !_produsenList[i].aktif;
      notifyListeners();
    }
  }

  void hapusProdusen(String id) {
    _produsenList.removeWhere((x) => x.id == id);
    notifyListeners();
  }

  // ── Mitra ──
  final List<MitraModel> _mitraList = [
    MitraModel(
      id: 'M001',
      namaUsaha: 'Toko Rempah Jaya',
      kontak: '083456789012',
      alamat: 'Jl. Harapan No. 10, Batam',
      jenisUsaha: 'Distributor',
    ),
    MitraModel(
      id: 'M002',
      namaUsaha: 'CV. Nusantara Spice',
      kontak: '084567890123',
      alamat: 'Jl. Maju No. 3, Batam',
      jenisUsaha: 'Retailer',
    ),
  ];

  List<MitraModel> get mitraList => List.unmodifiable(_mitraList);

  void tambahMitra(MitraModel m) {
    _mitraList.add(m);
    notifyListeners();
  }

  void updateMitra(MitraModel m) {
    final i = _mitraList.indexWhere((x) => x.id == m.id);
    if (i != -1) {
      _mitraList[i] = m;
      notifyListeners();
    }
  }

  void hapusMitra(String id) {
    _mitraList.removeWhere((x) => x.id == id);
    notifyListeners();
  }

  // ── Produksi ──
  final List<ProduksiModel> _produksiList = [
    ProduksiModel(
      id: 'PR001',
      produsenId: 'P001',
      produsenNama: 'Budi Santoso',
      produk: 'Lada Hitam',
      jumlahKg: 50,
      hargaPerKg: 85000,
      statusStok: 'Tersedia',
      tanggal: DateTime(2026, 4, 20),
    ),
    ProduksiModel(
      id: 'PR002',
      produsenId: 'P002',
      produsenNama: 'Siti Aminah',
      produk: 'Kayu Manis',
      jumlahKg: 30,
      hargaPerKg: 60000,
      statusStok: 'Habis',
      tanggal: DateTime(2026, 4, 22),
    ),
  ];

  List<ProduksiModel> get produksiList => List.unmodifiable(_produksiList);

  void tambahProduksi(ProduksiModel p) {
    _produksiList.add(p);
    notifyListeners();
  }

  void hapusProduksi(String id) {
    _produksiList.removeWhere((x) => x.id == id);
    notifyListeners();
  }

  // ── Transaksi ──
  final List<TransaksiModel> _transaksiList = [
    TransaksiModel(
      id: 'T001',
      produsenId: 'P001',
      produsenNama: 'Budi Santoso',
      mitraId: 'M001',
      mitraNama: 'Toko Rempah Jaya',
      produk: 'Lada Hitam',
      jumlah: 20,
      totalHarga: 1700000,
      status: 'Menunggu Konfirmasi',
      tanggal: DateTime(2026, 4, 25),
      konfirmasiMitra: 'sudah_sampai',
      konfirmasiAdmin: null,
    ),
    TransaksiModel(
      id: 'T002',
      produsenId: 'P002',
      produsenNama: 'Siti Aminah',
      mitraId: 'M002',
      mitraNama: 'CV. Nusantara Spice',
      produk: 'Kayu Manis',
      jumlah: 15,
      totalHarga: 900000,
      status: 'Selesai',
      tanggal: DateTime(2026, 4, 23),
      konfirmasiMitra: 'sudah_sampai',
      konfirmasiAdmin: 'dikonfirmasi',
    ),
  ];

  List<TransaksiModel> get transaksiList => List.unmodifiable(_transaksiList);

  void konfirmasiPembayaran(String id, bool dikonfirmasi) {
    final i = _transaksiList.indexWhere((x) => x.id == id);
    if (i != -1) {
      _transaksiList[i].konfirmasiAdmin =
          dikonfirmasi ? 'dikonfirmasi' : 'ditolak';
      _transaksiList[i].status = dikonfirmasi ? 'Selesai' : 'Ditolak';
      notifyListeners();
    }
  }

  // ── Stats untuk dashboard ──
  int get totalProdusen => _produsenList.length;
  int get totalMitra => _mitraList.length;
  int get totalProduksi => _produksiList.length;
  int get totalTransaksi => _transaksiList.length;
  int get transaksiMenunggu =>
      _transaksiList.where((t) => t.konfirmasiAdmin == null && t.konfirmasiMitra == 'sudah_sampai').length;
  double get totalPendapatan =>
      _transaksiList.where((t) => t.status == 'Selesai').fold(0, (s, t) => s + t.totalHarga);
}