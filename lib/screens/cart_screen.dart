import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('cart') ?? [];

    setState(() {
      cartItems = data.map((e) {
        final item = MapEncoding.fromUriEncoded(e);
        item["qty"] = int.tryParse(item["qty"] ?? "1") ?? 1;
        return item;
      }).toList();
    });
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data =
        cartItems.map((e) => MapEncoding.toUriEncoded(e)).toList();

    await prefs.setStringList('cart', data);
  }

  void updateQty(int index, int delta) {
    setState(() {
      int qty = cartItems[index]["qty"];
      qty += delta;
      if (qty < 1) qty = 1;

      cartItems[index]["qty"] = qty;
      saveCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Keranjang")),
      body: cartItems.isEmpty
          ? Center(child: Text("Keranjang kosong"))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (_, i) {
                final item = cartItems[i];

                return ListTile(
                  title: Text(item["nama"]),
                  subtitle: Text("Harga: ${item["harga"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () => updateQty(i, -1),
                          icon: Icon(Icons.remove)),
                      Text(item["qty"].toString()),
                      IconButton(
                          onPressed: () => updateQty(i, 1),
                          icon: Icon(Icons.add)),
                    ],
                  ),
                );
              },
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