import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Produk")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nama Produk"),
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: "Stok"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final product = {
                  "nama": nameController.text,
                  "stok": int.tryParse(stockController.text) ?? 0
                };
                Navigator.pop(context, product);
              },
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
} 