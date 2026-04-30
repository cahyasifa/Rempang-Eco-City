import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/bottom_nav_bar.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'product_detail_screen.dart';

final List<ProductModel> allProducts = [
  ProductModel(id: '1',  name: 'Ikan Selar Kuning', price: 30000,  stock: 25, category: 'Ikan',  image: 'assets/images/udang.jpg'),
  ProductModel(id: '2',  name: 'Ikan Tongkol',       price: 35000,  stock: 20, category: 'Ikan',  image: 'assets/images/udang.jpg'),
  ProductModel(id: '3',  name: 'Ikan Kembung',        price: 30000,  stock: 20, category: 'Ikan',  image: 'assets/images/udang.jpg'),
  ProductModel(id: '4',  name: 'Ikan Kembung 2',      price: 30000,  stock: 20, category: 'Ikan',  image: 'assets/images/udang.jpg'),
  ProductModel(id: '5',  name: 'Udang Windu',         price: 50000,  stock: 20, category: 'Udang', image: 'assets/images/udang.jpg'),
  ProductModel(id: '6',  name: 'Udang Galah',         price: 50000,  stock: 20, category: 'Udang', image: 'assets/images/udang.jpg'),
  ProductModel(id: '7',  name: 'Lobster',              price: 100000, stock: 25, category: 'Udang', image: 'assets/images/udang.jpg'),
  ProductModel(id: '8',  name: 'Udang Jerbung',       price: 50000,  stock: 24, category: 'Udang', image: 'assets/images/udang.jpg'),
  ProductModel(id: '9',  name: 'Cumi Sero',           price: 50000,  stock: 25, category: 'Cumi',  image: 'assets/images/udang.jpg'),
  ProductModel(id: '10', name: 'Cumi Bangka',         price: 45000,  stock: 25, category: 'Cumi',  image: 'assets/images/udang.jpg'),
  ProductModel(id: '11', name: 'Sotong',               price: 100000, stock: 25, category: 'Cumi',  image: 'assets/images/udang.jpg'),
  ProductModel(id: '12', name: 'Cumi',                 price: 50000,  stock: 25, category: 'Cumi',  image: 'assets/images/udang.jpg'),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  final List<Widget> _screens = const [
    HomeContent(),
    CartScreen(),
    OrdersScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _navIndex, children: _screens),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

// ─────────────────────────────────────────
class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _selectedCategory = 'Ikan';
  String _searchQuery      = '';
  final _searchCtrl        = TextEditingController();
  final List<String> _categories = ['Ikan', 'Udang', 'Cumi'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ProductModel> get _filtered {
    return allProducts.where((p) {
      final matchCat    = p.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header: Logo + Search bar ──
            Container(
              color: AppColors.bgPrimary,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                children: [
                  // Logo row
                  Row(
                    children: [
                      const AppLogo(height: 36, white: false),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search bar
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(Icons.search,
                            color: AppColors.iconGrey, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (v) =>
                                setState(() => _searchQuery = v),
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Cari produk...',
                              hintStyle: TextStyle(
                                  color: AppColors.iconGrey,
                                  fontSize: 14),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.close,
                                  color: AppColors.iconGrey, size: 18),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Category chips ──
            Container(
              color: AppColors.bgPrimary,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: _categories.map((cat) {
                  final sel = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel
                              ? AppColors.blue
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: sel
                                  ? AppColors.blue
                                  : AppColors.divider),
                        ),
                        child: Text(cat,
                            style: TextStyle(
                                color: sel
                                    ? AppColors.white
                                    : AppColors.textSecondary,
                                fontWeight: sel
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                fontSize: 13)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // ── Product grid ──
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off,
                              size: 48, color: AppColors.iconGrey),
                          const SizedBox(height: 12),
                          Text(
                            'Produk "$_searchQuery" tidak ditemukan',
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) =>
                          ProductCard(product: _filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  String _formatRp(int val) => 'Rp ${val.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';

  @override
  Widget build(BuildContext context) {
    final cart   = context.watch<CartProvider>();
    final inCart = cart.isInCart(product.id);

    return GestureDetector(
      // ── Tap → buka detail produk ──
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12)),
                child: Image.asset(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFE8E0D5),
                    child: const Icon(Icons.set_meal,
                        color: AppColors.iconGrey, size: 48),
                  ),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text('${_formatRp(product.price)}/kg',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Stok: ${product.stock}kg',
                          style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary)),
                      // Tombol + kecil di card
                      GestureDetector(
                        onTap: () {
                          context
                              .read<CartProvider>()
                              .addToCart(product);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                            content:
                                Text('${product.name} ditambahkan'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: AppColors.blue,
                          ));
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: inCart
                                ? AppColors.successGreen
                                : AppColors.blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                              inCart ? Icons.check : Icons.add,
                              color: AppColors.white,
                              size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}