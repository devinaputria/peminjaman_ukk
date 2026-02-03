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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // ================= FORM TAMBAH / EDIT =================
  void showForm({Map<String, dynamic>? kategori}) {
    kategoriController.text = kategori?['nama_kategori'] ?? '';

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                kategori == null ? 'Tambah Kategori' : 'Edit Kategori',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A5191),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: kategoriController,
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
                  prefixIcon: const Icon(Icons.category, color: Color(0xFF2A5191)),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (kategoriController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Nama kategori wajib diisi')),
                        );
                        return;
                      }

                      try {
                        if (kategori == null) {
                          await supabase.from('kategori').insert({
                            'nama_kategori': kategoriController.text,
                          });
                        } else {
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A5191),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Simpan'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ================= DELETE DENGAN KONFIRMASI =================
  void deleteKategori(dynamic id, String namaKategori) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "$namaKategori"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await supabase.from('kategori').delete().eq('id', id);
        fetchKategori();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Kategori berhasil dihapus')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal hapus: $e')));
      }
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FC),
      appBar: AppBar(
        title: const Text(
          'Manajemen Kategori',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2A5191),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showForm(),
        backgroundColor: const Color(0xFF2A5191),
        icon: const Icon(Icons.add),
        label: const Text("Tambah Kategori"),
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
                  padding: const EdgeInsets.all(16),
                  itemCount: kategoriList.length,
                  itemBuilder: (context, index) {
                    final kategori = kategoriList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFF2A5191).withOpacity(0.1),
                          child: const Icon(Icons.category, color: Color(0xFF2A5191)),
                        ),
                        title: Text(
                          kategori['nama_kategori'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => showForm(kategori: kategori),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteKategori(
                                    kategori['id'], kategori['nama_kategori']),
                              ),
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
