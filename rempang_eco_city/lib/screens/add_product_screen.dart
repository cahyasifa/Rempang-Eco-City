import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key); // ← tambah const constructor

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Produk")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama Produk"),
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: "Stok"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final product = {
                  "nama": nameController.text,
                  "stok": int.tryParse(stockController.text) ?? 0
                };
                Navigator.pop(context, product);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}