import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> dipinjam = [];
  List<Map<String, dynamic>> dikembalikan = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    setState(() => loading = true);

    final result = await supabase.from('peminjaman').select();

    final dipinjamList = <Map<String, dynamic>>[];
    final dikembalikanList = <Map<String, dynamic>>[];

    for (var item in result) {
      final status = (item['status'] ?? '').toString().toLowerCase();
      if (status == 'dipinjam' || status == 'menunggu') {
        dipinjamList.add(item);
      } else {
        dikembalikanList.add(item);
      }
    }

    setState(() {
      dipinjam = dipinjamList;
      dikembalikan = dikembalikanList;
      loading = false;
    });
  }

  Color _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s == 'dipinjam' || s == 'menunggu') return Colors.orange;
    if (s == 'dikembalikan') return Colors.green;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Peminjaman')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchRiwayat,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Dipinjam',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  ...dipinjam.map((item) => Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading:
                              const Icon(Icons.build, color: Colors.blue),
                          title: Text(item['alat'] ?? ''),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(item['status'] ?? '')
                                  .withAlpha(51),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item['status'] ?? '',
                              style: TextStyle(
                                color: _getStatusColor(item['status'] ?? ''),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),
                  const Text(
                    'Dikembalikan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  ...dikembalikan.map((item) => Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading:
                              const Icon(Icons.build, color: Colors.blue),
                          title: Text(item['alat'] ?? ''),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(item['status'] ?? '')
                                  .withAlpha(51),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item['status'] ?? '',
                              style: TextStyle(
                                color: _getStatusColor(item['status'] ?? ''),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
