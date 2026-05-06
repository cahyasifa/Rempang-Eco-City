class TransaksiModel {
  final String id;
  final String mitra;
  final String produk;
  final String jumlah;
  final String harga;
  final String tanggal;
  final String status; // 'Selesai' atau 'Ditolak'
  final String? alasanTolak;

  const TransaksiModel({
    required this.id,
    required this.mitra,
    required this.produk,
    required this.jumlah,
    required this.harga,
    required this.tanggal,
    required this.status,
    this.alasanTolak,
  });
}