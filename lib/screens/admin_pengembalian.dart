import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminPengembalianPage extends StatefulWidget {
  const AdminPengembalianPage({super.key});

  @override
  State<AdminPengembalianPage> createState() => _AdminPengembalianPageState();
}

class _AdminPengembalianPageState extends State<AdminPengembalianPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> pengembalianList = [];
  List<Map<String, dynamic>> peminjamanList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // ================= FETCH DATA =================
  Future<void> fetchData() async {
    setState(() => loading = true);
    try {
      // Ambil data pengembalian
      final pengembalianData = await supabase
          .from('pengembalian')
          .select('*')
          .order('tgl_kembali', ascending: false);

      // Ambil data peminjaman
      final peminjamanData = await supabase
          .from('peminjaman')
          .select('*');

      setState(() {
        pengembalianList = List<Map<String, dynamic>>.from(pengembalianData);
        peminjamanList = List<Map<String, dynamic>>.from(peminjamanData);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A5191),
        title: const Text('Pengembalian Alat'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : pengembalianList.isEmpty
              ? const Center(child: Text('Belum ada pengembalian'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pengembalianList.length,
                  itemBuilder: (context, index) {
                    final pengembalian = pengembalianList[index];

                    // Cocokkan peminjaman
                    final peminjaman = peminjamanList.firstWhere(
                      (pmj) => pmj['id'] == pengembalian['peminjaman_id'],
                      orElse: () => {},
                    );

                    final nama = peminjaman['user_id'] ?? 'Unknown';
                    final alat = peminjaman['alat_id']?.toString() ?? 'Tidak ada';
                    final status = peminjaman['status'] ?? 'Dipinjam';
                    final tglKembali = pengembalian['tgl_kembali'] ?? '-';

                    Color statusColor =
                        status.toLowerCase() == 'dikembalikan'
                            ? Colors.green
                            : Colors.orange;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF2A5191).withOpacity(0.1),
                          child: const Icon(Icons.person, color: Color(0xFF2A5191)),
                        ),
                        title: Text(nama),
                        subtitle: Text('Alat: $alat\nTgl Kembali: $tglKembali'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
