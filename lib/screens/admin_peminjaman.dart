import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminPeminjamanPage extends StatefulWidget {
  const AdminPeminjamanPage({super.key});

  @override
  State<AdminPeminjamanPage> createState() => _AdminPeminjamanPageState();
}

class _AdminPeminjamanPageState extends State<AdminPeminjamanPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> peminjamanList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPeminjaman();
  }

  // ================= FETCH DATA DARI SUPABASE =================
  Future<void> fetchPeminjaman() async {
    setState(() => loading = true);

    try {
      final data = await supabase
          .from('peminjaman')
          .select('*, user:user_id(nama)')
          .order('created_at', ascending: false);

      if (!mounted) return; // guard supaya aman

      setState(() {
        peminjamanList = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A5191),
        title: const Text('Daftar Peminjaman'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : peminjamanList.isEmpty
              ? const Center(child: Text('Belum ada peminjaman'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: peminjamanList.length,
                  itemBuilder: (context, index) {
                    final p = peminjamanList[index];
                    final userName = p['user']?['nama'] ?? 'Unknown';
                    final status = p['status'] ?? 'Dipinjam';
                    final tglSewa = p['tgl_sewa'] ?? '';

                    Color statusColor = Colors.blue;
                    if (status.toLowerCase() == 'dikembalikan') statusColor = Colors.green;
                    if (status.toLowerCase() == 'disetujui') statusColor = Colors.orange;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Tanggal Sewa: $tglSewa'),
                            const SizedBox(height: 2),
                            Text('Status: $status', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
