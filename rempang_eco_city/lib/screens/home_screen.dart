import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  HomeScreen({required this.onLogout});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "Semua";
  String searchQuery = "";

  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('products') ?? [];

    setState(() {
      products = data.map((e) => MapEncoding.fromUriEncoded(e)).toList();
    });
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cart = prefs.getStringList('cart') ?? [];

    product["qty"] = 1;

    cart.add(MapEncoding.toUriEncoded(product));

    await prefs.setStringList('cart', cart);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Ditambahkan ke keranjang")));
  }

  @override
  Widget build(BuildContext context) {
    List filtered = products.where((item) {
      final kategori = item["kategori"] ?? "Ikan";

      final matchCategory =
          selectedCategory == "Semua" || kategori == selectedCategory;

      final matchSearch = (item["nama"] ?? "")
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFF5EBDD),
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: widget.onLogout)
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          // 🔍 SEARCH BAGUS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Cari hasil tangkapan...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(height: 10),

          // kategori
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["Semua", "Ikan", "Udang", "Cumi"]
                  .map((cat) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: selectedCategory == cat,
                          onSelected: (_) =>
                              setState(() => selectedCategory = cat),
                        ),
                      ))
                  .toList(),
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: filtered.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (_, i) {
                final item = filtered[i];

                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: item["image"].toString().contains("assets")
                            ? Image.asset(item["image"], fit: BoxFit.cover)
                            : Image.file(File(item["image"]),
                                fit: BoxFit.cover),
                      ),
                      Text(item["nama"]),
                      Text(item["harga"]),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => addToCart(item),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

extension MapEncoding on Map<String, dynamic> {
  static Map<String, dynamic> fromUriEncoded(String encoded) {
    final decoded = Uri.splitQueryString(encoded);
    return decoded.map((k, v) => MapEntry(k, v));
  }

  static String toUriEncoded(Map<String, dynamic> map) {
    return map.entries
        .map((e) =>
            "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}")
        .join("&");
  }
}