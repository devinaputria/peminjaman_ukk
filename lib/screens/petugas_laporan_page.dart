import 'package:flutter/material.dart';

class PetugasLaporanPage extends StatelessWidget {
  const PetugasLaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Peminjaman'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul
            const Text(
              'LAPORAN PEMINJAMAN ALAT',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('Periode: Januari 2026'),
            const Divider(height: 32),

            // Tabel dummy
            Expanded(
              child: ListView(
                children: const [
                  _LaporanItem(
                    no: '1',
                    alat: 'Kamera Canon',
                    peminjam: 'Andi',
                    status: 'Kembali',
                  ),
                  _LaporanItem(
                    no: '2',
                    alat: 'Tripod',
                    peminjam: 'Siti',
                    status: 'Dipinjam',
                  ),
                  _LaporanItem(
                    no: '3',
                    alat: 'Laptop Asus',
                    peminjam: 'Budi',
                    status: 'Kembali',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Tombol cetak (dummy)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur cetak laporan (dummy)'),
                    ),
                  );
                },
                icon: const Icon(Icons.print),
                label: const Text('Cetak Laporan'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ================= ITEM LAPORAN =================

class _LaporanItem extends StatelessWidget {
  final String no;
  final String alat;
  final String peminjam;
  final String status;

  const _LaporanItem({
    required this.no,
    required this.alat,
    required this.peminjam,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(no)),
        title: Text(alat),
        subtitle: Text('Peminjam: $peminjam'),
        trailing: Text(
          status,
          style: TextStyle(
            color: status == 'Dipinjam' ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
