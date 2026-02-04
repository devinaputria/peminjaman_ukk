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

  Future<void> fetchData() async {
    setState(() => loading = true);
    try {
      // Ambil data pengembalian terbaru
      final pengembalianData = await supabase
          .from('pengembalian')
          .select('*')
          .order('tgl_kembali', ascending: false);

      // Ambil semua peminjaman beserta info alat
      final peminjamanData = await supabase
          .from('peminjaman')
          .select('*, alat:alat_id(nama_mesin)');

      setState(() {
        pengembalianList = List<Map<String, dynamic>>.from(pengembalianData);
        peminjamanList = List<Map<String, dynamic>>.from(peminjamanData);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

  String formatTanggal(dynamic tgl) {
    if (tgl == null) return '-';
    try {
      final d = DateTime.parse(tgl.toString());
      return "${d.day}-${d.month}-${d.year}";
    } catch (_) {
      return tgl.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A5191),
        title: const Text('Pengembalian Alat'),
        centerTitle: true,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
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

                    // Cari peminjaman sesuai sewa_id
                    final peminjaman = peminjamanList.firstWhere(
                      (pmj) => pmj['id'] == pengembalian['sewa_id'],
                      orElse: () => {},
                    );

                    // Nama user
                    final namaUser =
                        peminjaman['user_id'] ?? 'User tidak ditemukan';

                    // Nama alat
                    final namaAlat =
                        peminjaman['alat']?['nama_mesin'] ?? 'Tidak ada';

                    final tglKembali =
                        formatTanggal(pengembalian['tgl_kembali']);

                    final kondisi =
                        pengembalian['kondisi_kembali'] ?? 'Tidak ada data';

                    final denda = pengembalian['denda'] ?? 0;

                    // Status tampil
                    String statusTampil = denda > 0 ? "Ada Denda" : "Sudah Dikembalikan";
                    Color statusColor = denda > 0 ? Colors.red : Colors.green;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.blue.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A5191).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.assignment_return,
                            color: Color(0xFF2A5191),
                          ),
                        ),
                        title: Text(
                          "User: $namaUser",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              infoText("Nama Alat", namaAlat),
                              infoText("Kondisi", kondisi),
                              infoText("Tgl Kembali", tglKembali),
                              const SizedBox(height: 4),
                              Text(
                                "Denda: Rp $denda",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            statusTampil,
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

  Widget infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
