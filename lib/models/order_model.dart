import 'cart_item_model.dart';

enum OrderStatus { menunggu, diProses, selesai, ditolak }

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  OrderStatus status;
  final DateTime createdAt;
  final DateTime estimasiSampai;

  OrderModel({
    required this.id,
    required this.items,
    this.status = OrderStatus.menunggu,
    required this.createdAt,
    required this.estimasiSampai,
  });

  int get total => items.fold(0, (sum, i) => sum + i.subtotal);

  String get statusLabel {
    switch (status) {
      case OrderStatus.menunggu: return 'Menunggu';
      case OrderStatus.diProses: return 'Di Proses';
      case OrderStatus.selesai: return 'Selesai';
      case OrderStatus.ditolak: return 'Di Tolak';
    }
  }
}