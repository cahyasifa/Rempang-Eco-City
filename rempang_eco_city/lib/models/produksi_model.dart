class ProduksiModel {
  final String id;
  final String tanggal;
  final String kategori;    // ← baru: 'Ikan', 'Udang', 'Cumi'
  final String jenisProduk; // ← baru: nama spesifik yang diketik user
  final double jumlahKg;
  final double hargaPerKg;
  final String lokasiTangkap;
  final String catatan;

  ProduksiModel({
    required this.id,
    required this.tanggal,
    required this.kategori,
    required this.jenisProduk,
    required this.jumlahKg,
    required this.hargaPerKg,
    required this.lokasiTangkap,
    required this.catatan,
  });

  // Nama produk = jenisProduk (yang diketik user)
  String get produk => jenisProduk;
  double get totalHarga => jumlahKg * hargaPerKg;
}