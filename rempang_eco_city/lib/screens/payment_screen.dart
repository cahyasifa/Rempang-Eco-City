import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isSuccess      = false;
  String? _uploadedFile;
  final _addressCtrl   = TextEditingController();
  final _detailCtrl    = TextEditingController();
  bool _showAddAddress = false;
  bool _addressSaved   = false;

  @override
  void dispose() {
    _addressCtrl.dispose();
    _detailCtrl.dispose();
    super.dispose();
  }

  String _formatRp(int val) => 'Rp ${val.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';

  void _bayar() {
    if (!_addressSaved || _addressCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap lengkapi alamat pengiriman'),
          backgroundColor: AppColors.statusWaiting,
        ),
      );
      return;
    }
    final cart   = context.read<CartProvider>();
    final orders = context.read<OrderProvider>();
    orders.addOrder(cart.items.toList());
    cart.clear();
    setState(() => _isSuccess = true);
  }

  // ── AppBar dengan logo ──
  AppBar _buildAppBar(String title, {VoidCallback? onBack}) {
    return AppBar(
      backgroundColor: AppColors.blue,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          const AppLogo(height: 36, white: true),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final user = context.watch<UserProvider>().user;
    if (_isSuccess) return _buildSuccess();
    if (_showAddAddress) {
      return _buildAddAddress(
          user?.name ?? '', user?.phone ?? '');
    }
    return _buildForm(
        cart.totalPrice, user?.name ?? '', user?.phone ?? '');
  }

  // ─── Form Pembayaran ──────────────────────────
  Widget _buildForm(int total, String userName, String userPhone) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: _buildAppBar('Bayar Sekarang'),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [

              // ── Alamat ──
              _card(children: [
                Row(children: [
                  const Icon(Icons.location_on_outlined,
                      color: AppColors.blue, size: 18),
                  const SizedBox(width: 6),
                  const Text('Alamat Pengiriman',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _showAddAddress = true),
                    child: Text(
                      _addressSaved ? 'Ubah' : '+ Tambah',
                      style: const TextStyle(
                          color: AppColors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                if (_addressSaved &&
                    _addressCtrl.text.isNotEmpty) ...[
                  Text(
                    '$userName${userPhone.isNotEmpty ? " ($userPhone)" : ""}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _addressCtrl.text +
                        (_detailCtrl.text.isNotEmpty
                            ? ', ${_detailCtrl.text}'
                            : ''),
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary),
                  ),
                ] else
                  _warningBox(
                      'Belum ada alamat. Tap "+ Tambah" untuk menambahkan'),
              ]),

              const SizedBox(height: 14),

              // ── Pembayaran ──
              _card(children: [
                Row(children: const [
                  Icon(Icons.payment_outlined,
                      color: AppColors.blue, size: 18),
                  SizedBox(width: 6),
                  Text('Pembayaran',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                ]),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B3A6B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('BNI',
                          style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Transfer ke No. Rekening',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                        Text('1907278981',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => setState(
                      () => _uploadedFile = 'IMG_32145.jpg'),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.blue, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.blueLight.withOpacity(0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _uploadedFile != null
                              ? Icons.check_circle_outline
                              : Icons.upload_file_outlined,
                          color: AppColors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _uploadedFile ?? 'UNGGAH BUKTI TRANSFER',
                          style: const TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ]),
          ),
        ),
        _bottomBar(total),
      ]),
    );
  }

  // ─── Form Tambah Alamat ───────────────────────
  Widget _buildAddAddress(String userName, String userPhone) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: _buildAppBar('Tambah Alamat',
          onBack: () => setState(() => _showAddAddress = false)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _card(children: [
          // Info akun (read only)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.blue.withOpacity(0.2)),
            ),
            child: Row(children: [
              const Icon(Icons.person_outline,
                  color: AppColors.blue, size: 18),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName.isEmpty ? 'Nama Akun' : userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  Text(
                    userPhone.isEmpty
                        ? 'Nomor telepon belum diisi'
                        : userPhone,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
              const Spacer(),
              const Text('Dari akun',
                  style: TextStyle(
                      fontSize: 11, color: AppColors.blue)),
            ]),
          ),
          const SizedBox(height: 18),

          _fieldLabel('Alamat Lengkap'),
          const SizedBox(height: 6),
          TextField(
            controller: _addressCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText:
                  'Jl. Nama Jalan, No. Rumah, Kelurahan, Kecamatan',
            ),
          ),
          const SizedBox(height: 14),

          _fieldLabel('Detail Alamat (opsional)'),
          const SizedBox(height: 6),
          TextField(
            controller: _detailCtrl,
            decoration: const InputDecoration(
              hintText: 'Patokan, RT/RW, dll.',
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_addressCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alamat tidak boleh kosong'),
                      backgroundColor: AppColors.deleteRed,
                    ),
                  );
                  return;
                }
                setState(() {
                  _addressSaved   = true;
                  _showAddAddress = false;
                });
              },
              child: const Text('SIMPAN ALAMAT',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ]),
      ),
    );
  }

  // ─── Halaman Sukses ───────────────────────────
  Widget _buildSuccess() {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        automaticallyImplyLeading: false,
        title: const AppLogo(height: 40, white: true),
      ),
      body: Column(children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.successGreen, width: 2.5),
                  ),
                  child: const Icon(Icons.check,
                      color: AppColors.successGreen, size: 44),
                ),
                const SizedBox(height: 20),
                const Text('Pembayaran Berhasil!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.successGreen)),
                const SizedBox(height: 8),
                const Text('Pesanan kamu sedang diproses',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((r) => r.isFirst),
              child: const Text('Kembali ke Beranda',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ),
      ]),
    );
  }

  // ─── Helper Widgets ───────────────────────────
  Widget _card({required List<Widget> children}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05), blurRadius: 6)
          ],
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children),
      );

  Widget _warningBox(String msg) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.statusWaiting.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: AppColors.statusWaiting.withOpacity(0.3)),
        ),
        child: Row(children: [
          const Icon(Icons.info_outline,
              color: AppColors.statusWaiting, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(msg,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.statusWaiting)),
          ),
        ]),
      );

  Widget _fieldLabel(String text) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppColors.textPrimary));

  Widget _bottomBar(int total) => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, -2))
          ],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Belanja :',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14)),
              Text(_formatRp(total),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: _bayar,
              child: const Text('BAYAR SEKARANG',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ]),
      );
}