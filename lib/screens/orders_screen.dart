import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 3 tab: Semua | Menunggu | Di Proses
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.menunggu:  return AppColors.statusWaiting;
      case OrderStatus.diProses: return AppColors.statusProcess;
      case OrderStatus.selesai:  return AppColors.statusDone;
      case OrderStatus.ditolak:  return AppColors.statusRejected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProv = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        automaticallyImplyLeading: false,
        title: const AppLogo(height: 40, white: true),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.white,
          indicatorWeight: 3,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white.withOpacity(0.6),
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              fontFamily: 'Poppins'),
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Menunggu'),
            Tab(text: 'Di Proses'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(context, orderProv.orders),
          _buildList(context, orderProv.menunggu),
          _buildList(context, orderProv.diProses),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<OrderModel> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 60, color: AppColors.iconGrey),
            SizedBox(height: 12),
            Text('Belum ada pesanan',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 15)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, oi) {
        final order = orders[oi];
        return Column(
          children: order.items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4)
                ],
              ),
              child: Column(
                children: [
                  Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item.product.image,
                        width: 56, height: 56, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56, height: 56,
                          color: AppColors.divider,
                          child: const Icon(Icons.set_meal,
                              color: AppColors.iconGrey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                          Text(
                            'Rp ${item.product.price ~/ 1000}k/kg • ${item.qty}kg',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                          Text(
                            'Est: ${order.estimasiSampai.day}/${order.estimasiSampai.month}/${order.estimasiSampai.year}',
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.iconGrey),
                          ),
                        ],
                      ),
                    ),
                    // Badge status
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _statusColor(order.status)
                            .withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(order.statusLabel,
                          style: TextStyle(
                              color: _statusColor(order.status),
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ]),

                  // ── Tombol Konfirmasi Selesai ──
                  // Hanya muncul jika status Di Proses
                  if (order.status == OrderStatus.diProses) ...[
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showConfirmDialog(context, order.id);
                        },
                        icon: const Icon(Icons.check_circle_outline,
                            size: 16),
                        label: const Text(
                          'Konfirmasi Pesanan Sampai',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.successGreen,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.check_circle_outline,
              color: AppColors.successGreen),
          SizedBox(width: 8),
          Text('Konfirmasi Pesanan',
              style: TextStyle(fontSize: 16)),
        ]),
        content: const Text(
          'Apakah pesanan sudah sampai dan sesuai?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.iconGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<OrderProvider>()
                  .updateOrderStatus(orderId, OrderStatus.selesai);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pesanan dikonfirmasi selesai!'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen),
            child: const Text('Ya, Sudah Sampai'),
          ),
        ],
      ),
    );
  }
}