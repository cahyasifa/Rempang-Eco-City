import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int qty;

  CartItemModel({required this.product, this.qty = 1});

  int get subtotal => product.price * qty;
}