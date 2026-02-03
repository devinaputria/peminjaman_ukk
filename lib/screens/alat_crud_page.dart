import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlatCrudPage extends StatefulWidget {
  const AlatCrudPage({super.key});

  @override
  State<AlatCrudPage> createState() => _AlatCrudPageState();
}

class _AlatCrudPageState extends State<AlatCrudPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> alatList = [];
  List<Map<String, dynamic>> kategoriList = [];
  bool loading = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchKategori();
    fetchAlat();
  }

  Future<void> fetchKategori() async {
    final data = await supabase.from('kategori').select();
    setState(() {
      kategoriList = List<Map<String, dynamic>>.from(data);
    });
  }

  Future<void> fetchAlat() async {
    setState(() => loading = true);
    final data = await supabase.from('alat').select().order('id', ascending: true);
    setState(() {
      alatList = List<Map<String, dynamic>>.from(data);
      loading = false;
    });
  }

  // ==================== FORM TAMBAH / EDIT ====================
  void _tambahEditAlat({Map<String, dynamic>? alat}) {
    final namaController = TextEditingController(text: alat?['nama_mesin'] ?? '');
    final dendaController = TextEditingController(text: alat?['denda']?.toString() ?? '0');
    final stokController = TextEditingController(text: alat?['stok']?.toString() ?? '0');
    int? selectedKategori = alat?['kategori_id'];
    String? gambarUrl = alat?['gambar'];
    Uint8List? webImage;
    String? fileName;

    // Dropdown kondisi
    String? selectedKondisi = alat?['kondisi'] ?? 'Baik';
    const kondisiOptions = ['Baik', 'Rusak Ringan', 'Rusak Berat'];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(alat == null ? 'Tambah Alat' : 'Edit Alat'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(namaController, 'Nama Mesin'),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  value: selectedKategori,
                  decoration: _deco('Kategori'),
                  items: kategoriList.map((k) {
                    return DropdownMenuItem<int>(
                      value: k['id'],
                      child: Text(k['nama_kategori']),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setStateDialog(() {
                      selectedKategori = v;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildTextField(dendaController, 'Denda', isNumber: true),
                const SizedBox(height: 10),
                _buildTextField(stokController, 'Stok', isNumber: true),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedKondisi,
                  decoration: _deco('Kondisi'),
                  items: kondisiOptions.map((k) {
                    return DropdownMenuItem<String>(
                      value: k,
                      child: Text(k),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setStateDialog(() {
                      selectedKondisi = v;
                    });
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A5191),
                  ),
                  icon: const Icon(Icons.photo),
                  label: const Text('Pilih Foto'),
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      webImage = await image.readAsBytes();
                      fileName = image.name;
                      setStateDialog(() {});
                    }
                  },
                ),
                const SizedBox(height: 10),
                if (webImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(webImage!, height: 120),
                  ),
                if (gambarUrl != null && webImage == null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(gambarUrl, height: 120),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A5191),
              ),
              child: const Text('Simpan'),
              onPressed: () async {
                try {
                  String? finalGambarUrl = gambarUrl;
                  if (webImage != null) {
                    final path =
                        'alat/${DateTime.now().millisecondsSinceEpoch}_$fileName';
                    await supabase.storage.from('alat-images').uploadBinary(path, webImage!);
                    final url = supabase.storage.from('alat-images').getPublicUrl(path);
                    finalGambarUrl = url;
                  }

                  final data = {
                    'nama_mesin': namaController.text,
                    'kategori_id': selectedKategori,
                    'denda': int.tryParse(dendaController.text) ?? 0,
                    'stok': int.tryParse(stokController.text) ?? 0,
                    'kondisi': selectedKondisi,
                    'gambar': finalGambarUrl,
                  };

                  if (alat == null) {
                    await supabase.from('alat').insert(data);
                  } else {
                    await supabase.from('alat').update(data).eq('id', alat['id']);
                  }

                  Navigator.pop(context);
                  fetchAlat();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Berhasil disimpan')));
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Gagal: $e')));
                }
              },
            )
          ],
        ),
      ),
    );
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 247, 242),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A5191),
        title: const Text('Manajemen Alat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Tombol kembali
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A5191),
        onPressed: () => _tambahEditAlat(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alatList.length,
              itemBuilder: (_, i) {
                final alat = alatList[i];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: alat['gambar'] != null
                          ? Image.network(
                              alat['gambar'],
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 55,
                              height: 55,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image),
                            ),
                    ),
                    title: Text(
                      alat['nama_mesin'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Stok: ${alat['stok']} • Denda: Rp ${alat['denda']} • Kondisi: ${alat['kondisi']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => _tambahEditAlat(alat: alat),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Hapus Alat'),
                                content: Text('Apakah yakin ingin menghapus "${alat['nama_mesin']}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm != null && confirm) {
                              try {
                                await supabase.from('alat').delete().eq('id', alat['id']);
                                fetchAlat();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(content: Text('Berhasil dihapus')));
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Gagal hapus: $e')));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // ===== WIDGET BANTU =====
  Widget _buildTextField(TextEditingController c, String label, {bool isNumber = false}) {
    return TextField(
      controller: c,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: _deco(label),
    );
  }

  InputDecoration _deco(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}