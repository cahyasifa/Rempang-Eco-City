import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class RequestItem {
  final String productName;
  final int qty;
  final int price;
  final String image;
  final DateTime createdAt;
  String status; // 'Menunggu', 'Disetujui', 'Ditolak'

  RequestItem({
    required this.productName,
    required this.qty,
    required this.price,
    required this.image,
    required this.createdAt,
    this.status = 'Menunggu',
  });
}

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders   = [];
  final List<RequestItem> _requests = [];

  List<OrderModel>  get orders   => List.unmodifiable(_orders);
  List<RequestItem> get requests => List.unmodifiable(_requests);

  List<OrderModel> get menunggu =>
      _orders.where((o) => o.status == OrderStatus.menunggu).toList();
  List<OrderModel> get diProses =>
      _orders.where((o) => o.status == OrderStatus.diProses).toList();
  List<OrderModel> get selesai =>
      _orders.where((o) => o.status == OrderStatus.selesai).toList();
  List<OrderModel> get ditolak =>
      _orders.where((o) => o.status == OrderStatus.ditolak).toList();

  // Tambah pesanan dari keranjang
  void addOrder(List<CartItemModel> items) {
    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(items),
      createdAt: DateTime.now(),
      estimasiSampai: DateTime.now().add(const Duration(days: 5)),
    );
    _orders.insert(0, order);
    notifyListeners();
  }

  // Tambah permintaan ke produsen
  void addRequest({
    required String productName,
    required int qty,
    required int price,
    required String image,
  }) {
    _requests.insert(
      0,
      RequestItem(
        productName: productName,
        qty: qty,
        price: price,
        image: image,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      _orders[idx].status = status;
      notifyListeners();
    }
  }
}