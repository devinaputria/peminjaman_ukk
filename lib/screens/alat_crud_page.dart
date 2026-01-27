import 'package:flutter/material.dart';

class AlatCrudPage extends StatefulWidget {
  const AlatCrudPage({super.key});

  @override
  State<AlatCrudPage> createState() => _AlatCrudPageState();
}

class _AlatCrudPageState extends State<AlatCrudPage> {
  final List<Map<String, String>> alatList = [
    {'nama': 'Mesin Bor', 'kategori': 'Mesin'},
    {'nama': 'Sarung Tangan', 'kategori': 'K3'},
  ];

  // ===== TAMBAH / EDIT =====
  void _tambahEditAlat({Map<String, String>? alat, int? index}) {
    final namaController = TextEditingController(text: alat?['nama']);
    final kategoriController = TextEditingController(text: alat?['kategori']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(alat == null ? 'Tambah Alat' : 'Edit Alat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama Alat'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: kategoriController,
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (alat == null) {
                  alatList.add({
                    'nama': namaController.text,
                    'kategori': kategoriController.text,
                  });
                } else {
                  alatList[index!] = {
                    'nama': namaController.text,
                    'kategori': kategoriController.text,
                  };
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ===== HAPUS =====
  void _hapusAlat(int index) {
    setState(() {
      alatList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tambahEditAlat(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // ===== HEADER BIRU =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF2E5B9F),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOMBOL KEMBALI
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manajemen Alat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Tambah, edit, dan hapus data alat',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // ===== LIST ALAT =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alatList.length,
              itemBuilder: (_, i) {
                final alat = alatList[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF2E5B9F),
                      child: Icon(Icons.build, color: Colors.white),
                    ),
                    title: Text(alat['nama']!),
                    subtitle: Text('Kategori: ${alat['kategori']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () =>
                              _tambahEditAlat(alat: alat, index: i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _hapusAlat(i),
                        ),
                      ],
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
