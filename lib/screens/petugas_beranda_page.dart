import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetugasBerandaPage extends StatefulWidget {
  const PetugasBerandaPage({super.key});

@override
Widget build(BuildContext context) {
  print("PetugasBerandaPage dibangun!");
  return Scaffold(
    appBar: AppBar(title: Text('Beranda Petugas')),
    body: Center(child: Text('Isi Beranda')),
  );
}


  @override
  State<PetugasBerandaPage> createState() => _PetugasBerandaPageState();
}

class _PetugasBerandaPageState extends State<PetugasBerandaPage> {
  final supabase = Supabase.instance.client;

  List dataPeminjaman = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPeminjaman();
  }

  // ================= AMBIL DATA =================
  Future<void> fetchPeminjaman() async {
    final result = await supabase
        .from('peminjaman')
        .select()
        .eq('status', 'menunggu')
        .order('id');

    setState(() {
      dataPeminjaman = result;
      loading = false;
    });
  }

  // ================= SETUJU =================
  Future<void> setujui(String id) async {
    await supabase
        .from('peminjaman')
        .update({'status': 'disetujui'})
        .eq('id', id);

    fetchPeminjaman();
  }

  // ================= TOLAK =================
  Future<void> tolak(String id) async {
    await supabase
        .from('peminjaman')
        .update({'status': 'ditolak'})
        .eq('id', id);

    fetchPeminjaman();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dataPeminjaman.isEmpty) {
      return const Center(
        child: Text('Tidak ada pengajuan peminjaman'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dataPeminjaman.length,
      itemBuilder: (context, index) {
        final item = dataPeminjaman[index];

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ================= PEMINJAM =================
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['nama_peminjam'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          item['kelas'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(),

                // ================= INFO ALAT =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    infoChip(
                      icon: Icons.build,
                      label: item['alat'],
                    ),
                    infoChip(
                      icon: Icons.category,
                      label: item['kategori'],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ================= AKSI =================
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => tolak(item['id']),
                        icon: const Icon(Icons.close),
                        label: const Text('Tolak'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setujui(item['id']),
                        icon: const Icon(Icons.check),
                        label: const Text('Setuju'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
  
    // ================= CHIP =================
    Widget infoChip({required IconData icon, required String label}) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: Colors.blue.shade50,
    );
  }
}