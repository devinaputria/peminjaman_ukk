import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPeminjamanPage extends StatefulWidget {
  final Map<String, dynamic>? alat;

  const DetailPeminjamanPage({Key? key, this.alat}) : super(key: key);

  @override
  State<DetailPeminjamanPage> createState() => _DetailPeminjamanPageState();
}

class _DetailPeminjamanPageState extends State<DetailPeminjamanPage> {
  final _jumlahController = TextEditingController();
  final _tanggalController = TextEditingController();
  bool _loading = false;

  Future<void> submitPeminjaman() async {
    final jumlah = int.tryParse(_jumlahController.text.trim()) ?? 0;
    final tanggal = _tanggalController.text.trim();

    if (jumlah <= 0 || tanggal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi dengan benar")),
      );
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User belum login")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await Supabase.instance.client.from('peminjaman').insert({
        'user_id': user.id,
        'alat_id': widget.alat?['id'],
        'jumlah': jumlah,
        'tanggal_pengembalian': tanggal,
        'status': 'menunggu',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Peminjaman berhasil diajukan!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengajukan peminjaman: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  InputDecoration _deco(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alat = widget.alat;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        title: Text(alat?['nama_mesin'] ?? 'Detail Peminjaman'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Form Peminjaman',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Nama Alat (readonly)
                    TextFormField(
                      initialValue: alat?['nama_mesin'] ?? '',
                      decoration: _deco('Alat', ''),
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),

                    // Jumlah
                    TextField(
                      controller: _jumlahController,
                      keyboardType: TextInputType.number,
                      decoration: _deco('Jumlah', 'Masukkan jumlah yang dipinjam'),
                    ),
                    const SizedBox(height: 12),

                    // Tanggal Pengembalian
                    TextField(
                      controller: _tanggalController,
                      decoration: _deco('Tanggal Pengembalian', 'YYYY-MM-DD'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _loading ? null : submitPeminjaman,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 2,
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Ajukan Peminjaman',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Pastikan semua data sudah benar sebelum mengajukan',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            )
          ],
        ),
      ),
    );
  }
}
