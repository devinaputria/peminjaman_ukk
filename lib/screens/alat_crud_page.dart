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

  void _tambahEditAlat({Map<String, dynamic>? alat}) {
    final _formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: alat?['nama_mesin'] ?? '');
    final dendaController = TextEditingController(text: alat?['denda']?.toString() ?? '0');
    final stokController = TextEditingController(text: alat?['stok']?.toString() ?? '0');
    int? selectedKategori = alat?['kategori_id'];
    String? gambarUrl = alat?['gambar'];
    Uint8List? webImage;
    String? fileName;
    String selectedKondisi = alat?['kondisi'] ?? 'Baik';
    const kondisiOptions = ['Baik', 'Rusak Ringan', 'Rusak Berat'];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => Dialog(
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    alat == null ? 'Tambah Alat' : 'Edit Alat',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff01386C)),
                  ),
                  const SizedBox(height: 15),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _decoratedTextField(namaController, 'Nama Mesin', Icons.settings),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<int>(
                            value: selectedKategori,
                            decoration: const InputDecoration(border: InputBorder.none, labelText: 'Kategori'),
                            items: kategoriList
                                .map((k) => DropdownMenuItem<int>(
                                      value: k['id'],
                                      child: Text(k['nama_kategori']),
                                    ))
                                .toList(),
                            onChanged: (v) => setStateDialog(() => selectedKategori = v),
                            validator: (value) => value == null ? 'Pilih kategori' : null,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _decoratedTextField(dendaController, 'Denda', Icons.attach_money, isNumber: true)),
                            const SizedBox(width: 12),
                            Expanded(child: _decoratedTextField(stokController, 'Stok', Icons.inventory, isNumber: true)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedKondisi,
                            decoration: const InputDecoration(border: InputBorder.none, labelText: 'Kondisi'),
                            items: kondisiOptions.map((k) => DropdownMenuItem<String>(
                              value: k,
                              child: Text(k),
                            )).toList(),
                            onChanged: (v) => setStateDialog(() => selectedKondisi = v!),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.photo_camera, size: 22),
                          label: const Text('Pilih Gambar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff01386C),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                            if (image != null) {
                              webImage = await image.readAsBytes();
                              fileName = image.name;
                              setStateDialog(() {});
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        if (webImage != null)
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(image: MemoryImage(webImage!), fit: BoxFit.cover),
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                            ),
                          ),
                        if (gambarUrl != null && webImage == null)
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(image: NetworkImage(gambarUrl), fit: BoxFit.cover),
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal', style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          try {
                            String? finalGambarUrl = gambarUrl;
                            if (webImage != null) {
                              final path = 'alat/${DateTime.now().millisecondsSinceEpoch}_$fileName';
                              await supabase.storage.from('alat-images').uploadBinary(path, webImage!);
                              finalGambarUrl = supabase.storage.from('alat-images').getPublicUrl(path);
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
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil disimpan')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
                          }
                        },
                        child: const Text('Simpan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff01386C),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _decoratedTextField(TextEditingController c, String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: c,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xff01386C)),
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => value == null || value.isEmpty ? '$label tidak boleh kosong' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Alat'), backgroundColor: const Color(0xff01386C)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tambahEditAlat(),
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xff01386C),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: alatList.length,
              itemBuilder: (_, i) {
                final alat = alatList[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: _buildImage(alat['gambar']),
                    title: Text(alat['nama_mesin'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Stok: ${alat['stok']}, Denda: Rp ${alat['denda']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _tambahEditAlat(alat: alat)),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi Hapus'),
                                content: Text('Apakah Anda yakin ingin menghapus "${alat['nama_mesin']}"?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
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
                                await supabase.from('alat').delete().eq('id', alat['id']);
                                fetchAlat();
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil dihapus')));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal dihapus: $e')));
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

  Widget _buildImage(String? url) => url != null
      ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(url, width: 60, height: 60, fit: BoxFit.cover))
      : Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.image, color: Colors.white));
}
