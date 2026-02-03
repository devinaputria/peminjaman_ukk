import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  String selectedKategori = "Semua";

  // ================= Fetch data alat dari Supabase =================
  Future<List<Map<String, dynamic>>> fetchAlat() async {
    try {
      final data = await Supabase.instance.client
          .from('alat')
          .select('id, nama_mesin, kategori(id, nama_kategori)')
          .order('nama_mesin', ascending: true);

      print("Data alat: $data");
      return List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      print("Error fetchAlat: $e");
      throw Exception('Gagal mengambil data alat: $e');
    }
  }

  // ================= Warna kategori =================
  Color getCategoryColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'mesin':
        return Colors.blue;
      case 'alat_ukur':
        return Colors.green;
      case 'k3':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 247, 242),

      // ================= APPBAR =================
      appBar: AppBar(
        title: const Text(
          'Daftar Alat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff01386C),
        elevation: 2,
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAlat(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data alat kosong'));
          }

          final alatData = snapshot.data!;

          // ================= FILTER KATEGORI =================
          final List<String> categories = ["Semua"];
          for (var alat in alatData) {
            final k = alat['kategori']?['nama_kategori']?.toString();
            if (k != null && !categories.contains(k)) categories.add(k);
          }

          final filteredAlat = selectedKategori == "Semua"
              ? alatData
              : alatData
                  .where((alat) =>
                      alat['kategori']?['nama_kategori']?.toString() ==
                      selectedKategori)
                  .toList();

          return Column(
            children: [
              const SizedBox(height: 12),

              // ================= FILTER CHIP =================
              SizedBox(
                height: 50,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == selectedKategori;
                    final chipColor =
                        category == "Semua" ? Colors.grey : getCategoryColor(category);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: chipColor,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        onSelected: (_) {
                          setState(() {
                            selectedKategori = category;
                          });
                        },
                        elevation: isSelected ? 6 : 2,
                        shadowColor: Colors.grey.withOpacity(0.4),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // ================= LIST ALAT =================
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredAlat.length,
                  itemBuilder: (context, index) {
                    final alat = filteredAlat[index];
                    final kategoriNama =
                        alat['kategori']?['nama_kategori'] ?? 'Unknown';
                    final kategoriColor = getCategoryColor(kategoriNama);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              // ICON / PLACEHOLDER
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  color: kategoriColor.withOpacity(0.15),
                                  child: Icon(
                                    Icons.build,
                                    color: kategoriColor,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 14),

                              // INFO ALAT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      alat['nama_mesin'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Kategori: $kategoriNama",
                                      style: TextStyle(
                                        color: kategoriColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // TOMBOL PINJAM
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Pinjam ${alat['nama_mesin'] ?? ''}"),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff01386C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  elevation: 3,
                                  shadowColor: Colors.black45,
                                ),
                                child: const Text(
                                  "Pinjam",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
