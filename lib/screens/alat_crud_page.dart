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

  void _tambahEditAlat({Map<String, String>? alat, int? index}) {
    final namaController =
        TextEditingController(text: alat?['nama']);
    final kategoriController =
        TextEditingController(text: alat?['kategori']);

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
            const SizedBox(height: 8),
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

  void _hapusAlat(int index) {
    setState(() {
      alatList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Alat'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tambahEditAlat(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
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
              leading: const Icon(Icons.build, color: Colors.blue),
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
    );
  }
}
