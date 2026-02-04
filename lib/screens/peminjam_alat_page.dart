import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'detail_peminjaman_page.dart';

class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  Future<List<Map<String, dynamic>>> fetchAlat() async {
    final data = await Supabase.instance.client
        .from('alat')
        .select('id, nama_mesin, stok, denda')
        .order('nama_mesin', ascending: true);
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Alat')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAlat(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data alat kosong'));
          }

          final alatData = snapshot.data!;
          return ListView.builder(
            itemCount: alatData.length,
            itemBuilder: (context, index) {
              final alat = alatData[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(alat['nama_mesin']),
                  subtitle: Text('Stok: ${alat['stok']}'),
                  trailing: ElevatedButton(
                    child: const Text('Pinjam'),
                    onPressed: () {
                      // Kirim data alat ke halaman detail peminjaman
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPeminjamanPage(
                            alatId: alat['id'],
                            namaAlat: alat['nama_mesin'],
                            stok: alat['stok'],
                            denda: alat['denda'],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
