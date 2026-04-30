import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 3 tab: Permintaan | Di Tolak | Selesai
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              fontSize: 13,
              fontFamily: 'Poppins'),
          tabs: const [
            Tab(text: 'Permintaan'),
            Tab(text: 'Di Tolak'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Permintaan ke Produsen
          _buildRequestList(orderProv.requests),
          // Tab 2: Pesanan Di Tolak
          _buildOrderList(orderProv.ditolak, isDitolak: true),
          // Tab 3: Pesanan Selesai
          _buildOrderList(orderProv.selesai, isDitolak: false),
        ],
      ),
    );
  }

  // ── Daftar Permintaan ke Produsen ──
  Widget _buildRequestList(List<RequestItem> list) {
    if (list.isEmpty) {
      return _emptyState(
        icon: Icons.send_outlined,
        msg: 'Belum ada permintaan',
        sub: 'Minta produk dari halaman detail produk',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final req = list[i];
        return _requestCard(req);
      },
    );
  }

  Widget _requestCard(RequestItem req) {
    Color statusColor;
    switch (req.status) {
      case 'Disetujui':
        statusColor = AppColors.statusDone;
        break;
      case 'Ditolak':
        statusColor = AppColors.statusRejected;
        break;
      default:
        statusColor = AppColors.statusWaiting;
    }

    String _formatRp(int val) =>
        'Rp ${val.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 4)
        ],
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            req.image,
            width: 60, height: 60, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 60, height: 60, color: AppColors.divider,
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
              Text(req.productName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              Text(
                '${_formatRp(req.price)}/kg • ${req.qty} kg',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 3),
              Text(
                '${req.createdAt.day}/${req.createdAt.month}/${req.createdAt.year}',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.iconGrey),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(req.status,
              style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }

  // ── Daftar Pesanan (Di Tolak / Selesai) ──
  Widget _buildOrderList(List<OrderModel> orders,
      {required bool isDitolak}) {
    if (orders.isEmpty) {
      return _emptyState(
        icon: isDitolak
            ? Icons.cancel_outlined
            : Icons.check_circle_outline,
        msg: isDitolak
            ? 'Belum ada pesanan ditolak'
            : 'Belum ada pesanan selesai',
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item.product.image,
                      width: 60, height: 60, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60, height: 60,
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
                        const SizedBox(height: 3),
                        Text(
                          'Est: ${order.estimasiSampai.day}/${order.estimasiSampai.month}/${order.estimasiSampai.year}',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.iconGrey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: (isDitolak
                              ? AppColors.statusRejected
                              : AppColors.statusDone)
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isDitolak ? 'Di Tolak' : 'Selesai',
                      style: TextStyle(
                          color: isDitolak
                              ? AppColors.statusRejected
                              : AppColors.statusDone,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _emptyState(
          {required IconData icon,
          required String msg,
          String? sub}) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: AppColors.iconGrey),
            const SizedBox(height: 12),
            Text(msg,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 15)),
            if (sub != null) ...[
              const SizedBox(height: 4),
              Text(sub,
                  style: const TextStyle(
                      color: AppColors.iconGrey, fontSize: 13)),
            ],
          ],
        ),
      );
}