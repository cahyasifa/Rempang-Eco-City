import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login.dart';

class DashboardProdusen extends StatefulWidget {
  @override
  _DashboardProdusenState createState() => _DashboardProdusenState();
}

class _DashboardProdusenState extends State<DashboardProdusen> {
  List<Map<String, dynamic>> products = [];

  final namaController = TextEditingController();
  final hargaController = TextEditingController();
  final stokController = TextEditingController();
  final deskripsiController = TextEditingController();

  File? selectedImage;

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

  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data =
        products.map((e) => MapEncoding.toUriEncoded(e)).toList();

    await prefs.setStringList('products', data);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void addProduct() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Tambah Produk"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: namaController, decoration: InputDecoration(hintText: "Nama Produk")),
                TextField(controller: hargaController, decoration: InputDecoration(hintText: "Harga")),
                TextField(controller: stokController, decoration: InputDecoration(hintText: "Stok")),
                TextField(controller: deskripsiController, decoration: InputDecoration(hintText: "Deskripsi")),

                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: pickImage,
                  child: Text("Pilih Gambar"),
                ),

                SizedBox(height: 10),

                selectedImage != null
                    ? Image.file(selectedImage!, height: 100)
                    : Text("Belum pilih gambar"),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Batal")),
            ElevatedButton(
              onPressed: () {
                String nama = namaController.text.toLowerCase();

                String kategori = "Ikan";
                if (nama.contains("udang")) kategori = "Udang";
                if (nama.contains("cumi")) kategori = "Cumi";

                setState(() {
                  products.add({
                    "nama": namaController.text,
                    "harga": hargaController.text,
                    "stok": stokController.text,
                    "deskripsi": deskripsiController.text,
                    "kategori": kategori,
                    "image": selectedImage?.path ?? "assets/images/ikan.jpg",
                  });

                  saveProducts();
                });

                namaController.clear();
                hargaController.clear();
                stokController.clear();
                deskripsiController.clear();
                selectedImage = null;

                Navigator.pop(context);
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', false);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard Produsen"),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: logout)],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: addProduct,
            child: Text("Tambah Produk"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, i) {
                final item = products[i];
                return ListTile(
                  title: Text(item["nama"]),
                  subtitle: Text("Kategori: ${item["kategori"]}"),
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