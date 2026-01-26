import 'package:flutter/material.dart';

class KategoriCrudPage extends StatefulWidget {
  const KategoriCrudPage({super.key});

  @override
  State<KategoriCrudPage> createState() => _KategoriCrudPageState();
}

class _KategoriCrudPageState extends State<KategoriCrudPage> {
  final List<String> kategoriList = [
    'Mesin',
    'Alat Ukur',
    'K3',
  ];

  final TextEditingController kategoriController = TextEditingController();

  void showForm({int? index}) {
    if (index != null) {
      kategoriController.text = kategoriList[index];
    } else {
      kategoriController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: TextField(
          controller: kategoriController,
          decoration: const InputDecoration(
            labelText: 'Nama Kategori',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (kategoriController.text.isEmpty) return;

              setState(() {
                if (index == null) {
                  kategoriList.add(kategoriController.text);
                } else {
                  kategoriList[index] = kategoriController.text;
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

  void deleteKategori(int index) {
    setState(() {
      kategoriList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Kategori'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: kategoriList.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.category, color: Colors.blue),
              title: Text(kategoriList[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => showForm(index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteKategori(index),
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
