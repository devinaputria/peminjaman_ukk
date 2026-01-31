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

    final data = await supabase
        .from('alat')
        .select()
        .order('id', ascending: true);

    setState(() {
      alatList = List<Map<String, dynamic>>.from(data);
      loading = false;
    });
  }

  // ==================== FORM TAMBAH / EDIT ====================
  void _tambahEditAlat({Map<String, dynamic>? alat}) {
    final namaController =
        TextEditingController(text: alat?['nama_mesin'] ?? '');

    final dendaController =
        TextEditingController(text: alat?['denda']?.toString() ?? '0');

    final stokController =
        TextEditingController(text: alat?['stok']?.toString() ?? '0');

    final kondisiController =
        TextEditingController(text: alat?['kondisi'] ?? '');

    int? selectedKategori = alat?['kategori_id'];

    String? gambarUrl = alat?['gambar'];

    Uint8List? webImage;
    String? fileName;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

                _buildTextField(dendaController, 'Denda',
                    isNumber: true),

                const SizedBox(height: 10),

                _buildTextField(stokController, 'Stok',
                    isNumber: true),

                const SizedBox(height: 10),

                _buildTextField(kondisiController, 'Kondisi'),

                const SizedBox(height: 12),

                // ===== PILIH FOTO =====
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
                child: const Text('Batal')),

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

                    await supabase.storage
                        .from('alat-images')
                        .uploadBinary(path, webImage!);

                    final url = supabase.storage
                        .from('alat-images')
                        .getPublicUrl(path);

                    finalGambarUrl = url;
                  }

                  final data = {
                    'nama_mesin': namaController.text,
                    'kategori_id': selectedKategori,
                    'denda': int.tryParse(dendaController.text) ?? 0,
                    'stok': int.tryParse(stokController.text) ?? 0,
                    'kondisi': kondisiController.text,
                    'gambar': finalGambarUrl,
                  };

                  if (alat == null) {
                    await supabase.from('alat').insert(data);
                  } else {
                    await supabase
                        .from('alat')
                        .update(data)
                        .eq('id', alat['id']);
                  }

                  Navigator.pop(context);
                  fetchAlat();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Berhasil disimpan')),
                  );

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal: $e')),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  // ==================== UI UTAMA ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2A5191),
        onPressed: () => _tambahEditAlat(),
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // ===== HEADER =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF2A5191),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manajemen Alat',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Kelola data alat bengkel',
                  style:
                      TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: alatList.length,
                    itemBuilder: (_, i) {
                      final alat = alatList[i];

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: alat['gambar'] != null
                                ? Image.network(alat['gambar'],
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover)
                                : Container(
                                    width: 55,
                                    height: 55,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image),
                                  ),
                          ),

                          title: Text(
                            alat['nama_mesin'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),

                          subtitle: Text(
                              'Stok: ${alat['stok']} • Denda: Rp ${alat['denda']}'),

                          trailing: const Icon(Icons.edit),

                          onTap: () =>
                              _tambahEditAlat(alat: alat),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ===== WIDGET BANTU =====
  Widget _buildTextField(TextEditingController c, String label,
      {bool isNumber = false}) {
    return TextField(
      controller: c,
      keyboardType:
          isNumber ? TextInputType.number : TextInputType.text,
      decoration: _deco(label),
    );
  }

  InputDecoration _deco(String label) {
    return InputDecoration(
      labelText: label,
      border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
