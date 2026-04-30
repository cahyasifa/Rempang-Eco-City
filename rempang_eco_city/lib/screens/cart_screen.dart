import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../providers/cart_provider.dart';
import 'payment_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  String _formatRp(int val) => 'Rp ${val.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        // Logo saja, tanpa search icon
        title: const AppLogo(height: 40, white: true),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 64, color: AppColors.iconGrey),
                  SizedBox(height: 12),
                  Text('Keranjang masih kosong',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15)),
                  SizedBox(height: 4),
                  Text('Tambahkan produk dari beranda',
                      style: TextStyle(
                          color: AppColors.iconGrey, fontSize: 13)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (_, i) {
                      final item = cart.items[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    Colors.black.withOpacity(0.05),
                                blurRadius: 4)
                          ],
                        ),
                        child: Row(children: [
                          // Gambar
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            child: Image.asset(
                              item.product.image,
                              width: 80, height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80, height: 80,
                                color: AppColors.divider,
                                child: const Icon(Icons.set_meal,
                                    color: AppColors.iconGrey),
                              ),
                            ),
                          ),
                          // Info
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_formatRp(item.product.price)}/kg',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color:
                                            AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Qty + delete
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Row(children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.blue.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: Column(children: [
                                  _CartQtyBtn(
                                    icon: Icons.add,
                                    onTap: () => context
                                        .read<CartProvider>()
                                        .increment(item.product.id),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4),
                                    child: Text('${item.qty}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)),
                                  ),
                                  _CartQtyBtn(
                                    icon: Icons.remove,
                                    onTap: () => context
                                        .read<CartProvider>()
                                        .decrement(item.product.id),
                                  ),
                                ]),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => context
                                    .read<CartProvider>()
                                    .removeItem(item.product.id),
                                child: Container(
                                  width: 36, height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.deleteRed,
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                      Icons.delete_outline,
                                      color: AppColors.white,
                                      size: 20),
                                ),
                              ),
                            ]),
                          ),
                        ]),
                      );
                    },
                  ),
                ),

                // Total + Checkout
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, -2))
                    ],
                  ),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Belanja :',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textSecondary)),
                        Text(_formatRp(cart.totalPrice),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity, height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PaymentScreen()),
                        ),
                        child: const Text('LANJUT KE PEMBAYARAN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
    );
  }
}

class _CartQtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CartQtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 28, height: 24,
          child: Icon(icon, color: AppColors.blue, size: 15),
        ),
      );
}