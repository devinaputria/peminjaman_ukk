import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamanPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedAlat;
  const PeminjamanPage({super.key, required this.selectedAlat});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  final supabase = Supabase.instance.client;
  final Map<int, TextEditingController> jumlahControllers = {};
  final TextEditingController tanggalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var alat in widget.selectedAlat) {
      jumlahControllers[alat['id']] = TextEditingController(text: '1');
    }
  }

  @override
  void dispose() {
    for (var c in jumlahControllers.values) c.dispose();
    tanggalController.dispose();
    super.dispose();
  }

  Future<void> submitPeminjaman() async {
    for (var alat in widget.selectedAlat) {
      final jumlah = int.tryParse(jumlahControllers[alat['id']]!.text) ?? 1;
      await supabase.from('peminjaman').insert({
        'alat_id': alat['id'],
        'jumlah': jumlah,
        'tanggal_pengembalian': tanggalController.text,
        'status': 'menunggu',
        'created_at': DateTime.now().toIso8601String(),
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Peminjaman berhasil diajukan!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peminjaman')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Form Pengajuan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  for (var alat in widget.selectedAlat)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alat['nama'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('Denda: Rp ${alat['denda']}'),
                          TextField(
                            controller: jumlahControllers[alat['id']],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Jumlah',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tanggalController,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Pengembalian',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: submitPeminjaman,
                      child: const Text('Ajukan Peminjaman'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
