import 'package:flutter/material.dart';

class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  // Data alat
  final List<Map<String, dynamic>> alatList = const [
    {"id": 1, "nama_mesin": "Mesin Bor", "kategori": "Mesin",},
    {"id": 2, "nama_mesin": "Mesin Bubut", "kategori": "Mesin",},
    {"id": 3, "nama_mesin": "Mesin Frais", "kategori": "Mesin",},
    {"id": 4, "nama_mesin": "Mesin Bor Duduk", "kategori": "Mesin",},
    {"id": 5, "nama_mesin": "Jangka Sorong", "kategori": "Alat Ukur",},
    {"id": 6, "nama_mesin": "Mikrometer Luar", "kategori": "Alat Ukur",},
    {"id": 7, "nama_mesin": "Kacamata Safety", "kategori": "Safety",},
    {"id": 8, "nama_mesin": "Sarung Tangan", "kategori": "Safety",},
    {"id": 9, "nama_mesin": "Sepatu Safety", "kategori": "Safety",},
  ];

  // Untuk menyimpan kategori yang dipilih
  String selectedKategori = "Semua";

  @override
  Widget build(BuildContext context) {
    // Ambil daftar kategori unik
    final categories = ["Semua", ...{for (var alat in alatList) alat['kategori']}];

    // Filter alat berdasarkan kategori yang dipilih
    final filteredAlat = selectedKategori == "Semua"
        ? alatList
        : alatList.where((alat) => alat['kategori'] == selectedKategori).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Alat'),
        backgroundColor: const Color(0xff01386C),
      ),
      body: Column(
        children: [
          // Filter kategori
          Container(
            padding: const EdgeInsets.all(12),
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedKategori;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: const Color(0xff01386C),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) {
                      setState(() {
                        selectedKategori = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // List alat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredAlat.length,
              itemBuilder: (context, index) {
                final alat = filteredAlat[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(
                      alat['nama_mesin'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Kategori: ${alat['kategori']}"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Pinjam ${alat['nama_mesin']}"),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff01386C),
                      ),
                      child: const Text("Pinjam"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
