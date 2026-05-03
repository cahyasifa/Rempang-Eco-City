import 'package:flutter/material.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({Key? key}) : super(key: key); // ← tambah const constructor

  final List<Map<String, String>> requests = const [   // ← tambah const di sini
    {"mitra": "Mitra A", "produk": "Ikan Selar", "jumlah": "5kg"},
    {"mitra": "Mitra B", "produk": "Udang", "jumlah": "3kg"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(req["produk"]!),
            subtitle: Text("Mitra: ${req["mitra"]} | Jumlah: ${req["jumlah"]}"),
          ),
        );
      },
    );
  }
}