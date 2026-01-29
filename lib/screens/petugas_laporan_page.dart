import 'package:flutter/material.dart';

class PetugasLaporanPage extends StatelessWidget {
  const PetugasLaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ===== HEADER =====
          Container(
            height: 130,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, bottom: 20),
            alignment: Alignment.bottomLeft,
            decoration: const BoxDecoration(
              color: Color(0xFF2C4F8A),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: const Text(
              'Laporan Peminjaman',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ===== LIST LAPORAN =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: const [
                  LaporanCard(
                    alat: 'Sarung Tangan',
                    peminjam: 'Andi',
                    status: 'Kembali',
                  ),
                  LaporanCard(
                    alat: 'Mesin Bor',
                    peminjam: 'Depi',
                    status: 'Dipinjam',
                  ),
                  LaporanCard(
                    alat: 'Mesin Bubut',
                    peminjam: 'Budi',
                    status: 'Kembali',
                  ),
                ],
              ),
            ),
          ),

          // ===== TOMBOL CETAK =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF2C4F8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
            ),
          ),
        ],
      ),
    );
  }
}

// ================= CARD LAPORAN =================

class LaporanCard extends StatelessWidget {
  final String alat;
  final String peminjam;
  final String status;

  const LaporanCard({
    super.key,
    required this.alat,
    required this.peminjam,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isKembali = status == 'Kembali';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(Icons.person, color: Colors.blue),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alat,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Peminjam : $peminjam',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isKembali ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
