import 'package:flutter/material.dart';

class AlatPage extends StatelessWidget {
  const AlatPage({super.key});

  //data alat
  final List<Map<String, dynamic>> alatList = const [
    {
      "id": 1,
      "nama_mesin": "Mesin Bor",
      "kategori_id": 1,
      "denda": 5000,
      "stok": 1,
      "kondisi": "Baik",
      "created_at": "2026-01-14 12:42:20",
    },
    {
      "id": 2,
      "nama_mesin": "Mesin Bubut",
      "kategori_id": 1,
      "denda": 50000,
      "stok": 2,
      "kondisi": "Baik",
      "created_at": "2026-01-14 06:03:40",
    },
    {
      "id": 3,
      "nama_mesin": "Mesin Frais",
      "kategori_id": 1,
      "denda": 60000,
      "stok": 1,
      "kondisi": "Baik",
      "created_at": "2026-01-14 06:03:40",
    },
    {
      "id": 4,
      "nama_mesin": "Mesin Bor Duduk",
      "kategori_id": 1,
      "denda": 40000,
      "stok": 3,
      "kondisi": "Baik",
      "created_at": "2026-01-14 06:03:40",
    },
    {
      "id": 5,
      "nama_mesin": "Jangka Sorong",
      "kategori_id": 2,
      "denda": 15000,
      "stok": 5,
      "kondisi": "Baik",
      "created_at": "2026-01-14 06:03:40",
    },
    {
      "id": 6,
      "nama_mesin": "Mikrometer Luar",
      "kategori_id": 2,
      "denda": 20000,
      "stok": 4,
      "kondisi": "Baik",
      "created_at": "2026-01-14 06:03:40",
    },
    {
      "id": 7,
      "nama_mesin": "Kacamata Safety",
      "kategori_id": 3,
      "denda": 5000,
      "stok": 10,
      "kondisi": "Baik",
      "created_at": "2026-01-14 06:03:40",
    },
    {
      "id": 8,
      "nama_mesin": "Sarung Tangan",
      "kategori_id": 3,
      "denda": 3000,
      "stok": 20,
      "kondisi": "Baik",
      "created_at": "2026-01-14 06:03:40",
    },
    {
      "id": 9,
      "nama_mesin": "Sepatu Safety",
      "kategori_id": 3,
      "denda": 10000,
      "stok": 8,
      "kondisi": "Baik",
      "created_at": "2026-01-14 06:03:40",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Alat'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman sebelumnya
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: alatList.length,
        itemBuilder: (context, index) {
          final alat = alatList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alat["nama_mesin"],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text("ID: ${alat["id"]}"),
                  Text("Kategori ID: ${alat["kategori_id"]}"),
                  Text("Denda: Rp${alat["denda"]}"),
                  Text("Stok: ${alat["stok"]}"),
                  Text("Kondisi: ${alat["kondisi"]}"),
                  Text("Ditambahkan: ${alat["created_at"]}"),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Pinjam ${alat["nama_mesin"]}')),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Pinjam'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
