import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlatCrudPage extends StatefulWidget {
  const AlatCrudPage({super.key});

  @override
  State<AlatCrudPage> createState() => _AlatCrudPageState();
}

class _AlatCrudPageState extends State<AlatCrudPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> alatList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchAlat();
  }

  // ================= GET =================
  Future<void> fetchAlat() async {
    setState(() => loading = true);
    try {
      final data = await supabase.from('alat').select().order('id', ascending: true);
      setState(() {
        alatList = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print('Error fetch alat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil data alat')),
      );
    }
  }

  // ================= TAMBAH / EDIT =================
  void _tambahEditAlat({Map<String, dynamic>? alat}) {
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
            onPressed: () async {
              try {
                if (alat == null) {
                  await supabase.from('alat').insert({
                    'nama': namaController.text,
                    'kategori': kategoriController.text,
                  });
                } else {
                  await supabase.from('alat').update({
                    'nama': namaController.text,
                    'kategori': kategoriController.text,
                  }).eq('id', alat['id']);
                }
                Navigator.pop(context);
                fetchAlat();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(alat == null
                        ? 'Alat berhasil ditambah'
                        : 'Alat berhasil diupdate'),
                  ),
                );
              } catch (e) {
                print('Error simpan alat: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menyimpan alat')),
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
  void _hapusAlat(dynamic id) async {
    try {
      await supabase.from('alat').delete().eq('id', id);
      fetchAlat();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alat berhasil dihapus')),
      );
    } catch (e) {
      print('Error hapus alat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus alat')),
      );
    }
  }

  // ================= UI =================
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
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
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
                          title: Text(alat['nama'] ?? ''),
                          subtitle: Text('Kategori: ${alat['kategori'] ?? ''}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _tambahEditAlat(alat: alat),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _hapusAlat(alat['id']),
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
