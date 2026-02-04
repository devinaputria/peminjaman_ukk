import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController lamaSewaController = TextEditingController();

  List<Map<String, dynamic>> alatList = [];
  Map<String, dynamic>? selectedAlat;
  bool loadingAlat = true;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    fetchAlat();
  }

  Future<void> fetchAlat() async {
    try {
      final data = await Supabase.instance.client
          .from('alat')
          .select('id, nama_mesin, denda, stok, gambar')
          .order('nama_mesin', ascending: true);

      setState(() {
        alatList = List<Map<String, dynamic>>.from(data);
        if (alatList.isNotEmpty) selectedAlat = alatList[0];
        loadingAlat = false;
      });
    } catch (e) {
      setState(() => loadingAlat = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data alat: $e')),
      );
    }
  }

  Future<void> ajukanPeminjaman() async {
    if (selectedAlat == null ||
        jumlahController.text.isEmpty ||
        lamaSewaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    final jumlah = int.tryParse(jumlahController.text) ?? 0;
    final lamaSewa = int.tryParse(lamaSewaController.text) ?? 0;

    if (jumlah <= 0 || jumlah > selectedAlat!['stok']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jumlah melebihi stok (${selectedAlat!['stok']})'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => submitting = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw 'User belum login';

      await Supabase.instance.client.from('peminjaman').insert({
        'user_id': user.id,
        'tgl_sewa': DateTime.now().toIso8601String(),
        'lama_sewa': lamaSewa,
        'status': 'menunggu',
        'created_by': user.id,
        'alat_id': selectedAlat!['id'],
        'jumlah': jumlah,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Pengajuan ${selectedAlat!['nama_mesin']} ($jumlah item) berhasil!'),
          backgroundColor: const Color(0xFF2A5191),
        ),
      );

      // reset form
      jumlahController.clear();
      lamaSewaController.clear();
      setState(() {
        selectedAlat = alatList.isNotEmpty ? alatList[0] : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengajukan peminjaman: $e')),
      );
    } finally {
      setState(() => submitting = false);
    }
  }

  @override
  void dispose() {
    jumlahController.dispose();
    lamaSewaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Peminjaman'),
        backgroundColor: const Color(0xFF2A5191),
      ),
      body: loadingAlat
          ? const Center(child: CircularProgressIndicator())
          : alatList.isEmpty
              ? const Center(child: Text('Data alat kosong'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Form Pengajuan',
                        style:
                            TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),

                      // Dropdown alat
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: DropdownButton<Map<String, dynamic>>(
                            value: selectedAlat,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: alatList.map((alat) {
                              return DropdownMenuItem(
                                value: alat,
                                child: Row(
                                  children: [
                                    if (alat['gambar'] != null)
                                      Image.network(
                                        alat['gambar'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    else
                                      Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.build),
                                      ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          alat['nama_mesin'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Stok: ${alat['stok']} | Denda: Rp ${alat['denda']}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedAlat = value;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Jumlah
                      TextField(
                        controller: jumlahController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Jumlah',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Lama Sewa
                      TextField(
                        controller: lamaSewaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Lama Sewa (hari)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Tombol Ajukan
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: submitting ? null : ajukanPeminjaman,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A5191),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: submitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Ajukan Peminjaman',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
