import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPeminjamanPage extends StatefulWidget {
  final int alatId;
  final String namaAlat;
  final int stok;
  final int denda;

  const DetailPeminjamanPage({
    super.key,
    required this.alatId,
    required this.namaAlat,
    required this.stok,
    required this.denda,
  });

  @override
  State<DetailPeminjamanPage> createState() => _DetailPeminjamanPageState();
}

class _DetailPeminjamanPageState extends State<DetailPeminjamanPage> {
  final jumlahController = TextEditingController();
  final tanggalController = TextEditingController();
  bool loading = false;

  Future<void> submitPeminjaman() async {
    final jumlah = int.tryParse(jumlahController.text.trim()) ?? 0;
    final tanggal = tanggalController.text.trim();

    if (jumlah <= 0 || tanggal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi!')),
      );
      return;
    }

    if (jumlah > widget.stok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stok tersedia: ${widget.stok}')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw 'User belum login';

      await Supabase.instance.client.from('peminjaman').insert({
        'user_id': user.id,
        'alat_id': widget.alatId,
        'jumlah': jumlah,
        'tanggal_pengembalian': tanggal,
        'status': 'menunggu',
        'created_by': user.id,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Peminjaman berhasil diajukan!')),
      );

      Navigator.pop(context); // kembali ke halaman alat
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengajukan: $e')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    jumlahController.dispose();
    tanggalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Peminjaman')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Alat: ${widget.namaAlat}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Stok tersedia: ${widget.stok}'),
            const SizedBox(height: 12),
            Text('Denda per hari: Rp ${widget.denda}'),
            const SizedBox(height: 24),

            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tanggalController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Pengembalian (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : submitPeminjaman,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Ajukan Peminjaman'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
