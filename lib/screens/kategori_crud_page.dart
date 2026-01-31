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

  // ================= GET DATA =================
  Future<void> fetchKategori() async {
    setState(() => loading = true);

    try {
      final data = await supabase
          .from('kategori')
          .select()
          .order('id', ascending: true);

      setState(() {
        kategoriList = List<Map<String, dynamic>>.from(data);
        loading = false;
      });

    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // ================= FORM TAMBAH / EDIT =================
  void showForm({Map<String, dynamic>? kategori}) {

    // 👉 SESUAI KOLOM SUPABASE = nama_kategori
    kategoriController.text = kategori?['nama_kategori'] ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),

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

              if (kategoriController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nama kategori wajib diisi'),
                  ),
                );
                return;
              }

              try {

                // ===== TAMBAH =====
                if (kategori == null) {
                  await supabase.from('kategori').insert({
                    'nama_kategori': kategoriController.text,
                  });

                } 
                // ===== EDIT =====
                else {
                  await supabase.from('kategori').update({
                    'nama_kategori': kategoriController.text,
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal: $e')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ================= DELETE =================
  void deleteKategori(dynamic id) async {
    try {
      await supabase.from('kategori').delete().eq('id', id);

      fetchKategori();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil dihapus')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal hapus: $e')),
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
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())

          : kategoriList.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada kategori',
                    style: TextStyle(color: Colors.grey),
                  ),
                )

              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: kategoriList.length,

                  itemBuilder: (context, index) {
                    final kategori = kategoriList[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.category,
                              color: Colors.blue),
                        ),

                        // 👉 TAMPIL SESUAI KOLOM
                        title: Text(
                          kategori['nama_kategori'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.orange),

                              onPressed: () =>
                                  showForm(kategori: kategori),
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),

                              onPressed: () =>
                                  deleteKategori(kategori['id']),
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
