import 'package:flutter/material.dart';

class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  int selectedKategori = 0; // 0 = semua

  final List<Map<String, dynamic>> alatList = [
  {'nama': 'Mesin Bor', 'kategori': 1},
  {'nama': 'Mesin Bubut', 'kategori': 1},
  {'nama': 'Mesin Frais', 'kategori': 1},
  {'nama': 'Jangka Sorong', 'kategori': 2},
  {'nama': 'Mikrometer Luar', 'kategori': 2},
  {'nama': 'Kacamata Safety', 'kategori': 3},
  {'nama': 'Sarung Tangan', 'kategori': 3},
];


  @override
  Widget build(BuildContext context) {
    // FILTER DATA
    final filteredAlat = selectedKategori == 0
        ? alatList
        : alatList
            .where((alat) => alat['kategori'] == selectedKategori)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Alat'),
        backgroundColor: Colors.blue.shade700,
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // SEARCH
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari alat...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // FILTER KATEGORI
            Wrap(
              spacing: 8,
              children: [
                kategoriChip('Semua', 0),
                kategoriChip('Mesin', 1),
                kategoriChip('Alat Ukur', 2),
                kategoriChip('K3', 3),
              ],
            ),

            const SizedBox(height: 10),

            // GRID ALAT
            Expanded(
              child: GridView.builder(
                itemCount: filteredAlat.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final alat = filteredAlat[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            child: const Icon(
                              Icons.precision_manufacturing,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alat['nama'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${alat['harga']} / item',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget kategoriChip(String text, int kategoriId) {
    return ChoiceChip(
      label: Text(text),
      selected: selectedKategori == kategoriId,
      onSelected: (_) {
        setState(() {
          selectedKategori = kategoriId;
        });
      },
    );
  }
}
