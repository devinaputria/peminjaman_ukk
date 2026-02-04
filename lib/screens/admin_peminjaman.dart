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

  // ================= FETCH DATA =================
  Future<void> fetchPeminjaman() async {
    setState(() => loading = true);
    try {
      final data = await supabase
          .from('peminjaman')
          .select('*')
          .order('created_at', ascending: false);

      if (!mounted) return;

      setState(() {
        peminjamanList = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

  // ================= HITUNG HARI TERLAMBAT =================
  int hitungHariTerlambat(Map<String, dynamic> p) {
    try {
      final tglSewa = DateTime.parse(p['tgl_sewa']);
      final lama = int.tryParse(p['lama_sewa'].toString()) ?? 0;
      final batas = tglSewa.add(Duration(days: lama));
      final sekarang = DateTime.now();

      if (sekarang.isAfter(batas)) {
        return sekarang.difference(batas).inDays;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  // ================= PROSES KEMBALIKAN =================
  Future<void> prosesKembalikan(Map<String, dynamic> p, int dendaPerHari,
      int dendaRusak, String kondisiRusak) async {
    try {
      int hariTerlambat = hitungHariTerlambat(p);
      int totalDenda = (hariTerlambat * dendaPerHari) + dendaRusak;

      await supabase.from('pengembalian').insert({
        'sewa_id': p['id'],
        'tgl_kembali': DateTime.now().toIso8601String(),
        'kondisi_kembali': kondisiRusak,
        'denda': totalDenda,
      });

      await supabase
          .from('peminjaman')
          .update({'status': 'dikembalikan'})
          .eq('id', p['id']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Berhasil dikembalikan. Total denda: Rp $totalDenda')),
      );

      fetchPeminjaman();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal proses: $e')));
    }
  }

  // ================= DETAIL DIALOG DENGAN VALIDASI =================
  void bukaDetail(Map<String, dynamic> p) {
    final hariTerlambat = hitungHariTerlambat(p);

    final dendaPerHariController = TextEditingController();
    final dendaRusakController = TextEditingController();
    String rusakKategori = 'baik';

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          int dendaPerHari = int.tryParse(dendaPerHariController.text) ?? 0;
          int dendaRusak = int.tryParse(dendaRusakController.text) ?? 0;
          int totalDenda = (hariTerlambat * dendaPerHari) + dendaRusak;

          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Pengembalian',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2A5191)),
                    ),
                    const Divider(),
                    infoRow("Kode", p['kode_peminjaman'] ?? '-'),
                    infoRow("Tanggal Sewa", p['tgl_sewa'] ?? '-'),
                    infoRow("Lama Sewa", "${p['lama_sewa'] ?? 0} hari"),
                    infoRow("Hari Terlambat", "$hariTerlambat hari"),
                    const SizedBox(height: 10),

                    const Text("Denda Per Hari:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: dendaPerHariController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: "Rp ",
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty || int.tryParse(val) == 0) {
                          return 'Denda Per Hari wajib diisi';
                        }
                        return null;
                      },
                      onChanged: (_) => setStateDialog(() {}),
                    ),

                    const SizedBox(height: 10),
                    const Text("Kondisi Barang:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButton<String>(
                      value: rusakKategori,
                      items: [
                        DropdownMenuItem(value: 'baik', child: Text('Baik')),
                        DropdownMenuItem(value: 'ringan', child: Text('Ringan')),
                        DropdownMenuItem(value: 'sedang', child: Text('Sedang')),
                        DropdownMenuItem(value: 'berat', child: Text('Berat')),
                      ],
                      onChanged: (val) {
                        setStateDialog(() {
                          rusakKategori = val!;
                          switch (rusakKategori) {
                            case 'ringan':
                              dendaRusakController.text = "2000";
                              break;
                            case 'sedang':
                              dendaRusakController.text = "3000";
                              break;
                            case 'berat':
                              dendaRusakController.text = "10000";
                              break;
                            default:
                              dendaRusakController.text = "0";
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 10),
                    const Text("Denda Rusak:", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: dendaRusakController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: "Rp ",
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Denda rusak wajib diisi';
                        }
                        return null;
                      },
                      onChanged: (_) => setStateDialog(() {}),
                    ),

                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: totalDenda > 0
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        'TOTAL DENDA: Rp $totalDenda',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: totalDenda > 0 ? Colors.red : Colors.green),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal")),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                prosesKembalikan(
                                    p, dendaPerHari, dendaRusak, rusakKategori);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text("Kembalikan"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(": $value")),
        ],
      ),
    );
  }

  // ================= UI UTAMA =================
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
                    final status = p['status'] ?? 'dipinjam';
                    Color warna = Colors.blue;
                    if (status == 'dikembalikan') warna = Colors.green;
                    if (status == 'disetujui') warna = Colors.orange;

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () => bukaDetail(p),
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color(0xFF2A5191).withOpacity(0.1),
                          child: const Icon(Icons.inventory,
                              color: Color(0xFF2A5191)),
                        ),
                        title: Text(p['kode_peminjaman'] ?? '-',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Tanggal: ${p['tgl_sewa']}'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: warna.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(status,
                              style: TextStyle(
                                  color: warna, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
