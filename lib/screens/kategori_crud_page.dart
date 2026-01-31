import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriCrudPage extends StatefulWidget {
  const KategoriCrudPage({super.key});

  @override
  State<KategoriCrudPage> createState() => _KategoriCrudPageState();
}

class _KategoriCrudPageState extends State<KategoriCrudPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> kategoriList = [];
  bool loading = true;

  final TextEditingController kategoriController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  // ================= GET =================
  Future<void> fetchKategori() async {
    setState(() => loading = true);
    try {
      final data = await supabase.from('kategori').select().order('id', ascending: true);
      setState(() {
        kategoriList = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print('Error fetch kategori: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil data kategori')),
      );
    }
  }

  // ================= TAMBAH / EDIT =================
  void showForm({Map<String, dynamic>? kategori}) {
    kategoriController.text = kategori?['nama'] ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          kategori == null ? 'Tambah Kategori' : 'Edit Kategori',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
            onPressed: () async {
              if (kategoriController.text.isEmpty) return;

              try {
                if (kategori == null) {
                  await supabase.from('kategori').insert({
                    'nama': kategoriController.text,
                  });
                } else {
                  await supabase.from('kategori').update({
                    'nama': kategoriController.text,
                  }).eq('id', kategori['id']);
                }

                Navigator.pop(context);
                fetchKategori();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      kategori == null
                          ? 'Kategori berhasil ditambah'
                          : 'Kategori berhasil diupdate',
                    ),
                  ),
                );
              } catch (e) {
                print('Error simpan kategori: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menyimpan kategori')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ================= HAPUS =================
  void deleteKategori(dynamic id) async {
    try {
      await supabase.from('kategori').delete().eq('id', id);
      fetchKategori();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil dihapus')),
      );
    } catch (e) {
      print('Error hapus kategori: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus kategori')),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Kategori'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 3,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 28),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : kategoriList.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada kategori',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: kategoriList.length,
                  itemBuilder: (context, index) {
                    final kategori = kategoriList[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.category, color: Colors.blue),
                        ),
                        title: Text(
                          kategori['nama'] ?? '',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: SizedBox(
                          width: 96,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => showForm(kategori: kategori),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteKategori(kategori['id']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
