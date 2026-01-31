import 'package:flutter/material.dart';
import 'detail_peminjaman_page.dart';

class AdminPengembalianPage extends StatelessWidget {
  const AdminPengembalianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7), // cream background
      body: Column(
        children: [
          // ===== HEADER CUSTOM =====
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            color: const Color(0xFF2A5191), // warna AppBar Figma
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Peminjaman',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // ===== LIST PEMINJAMAN =====
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _peminjamanItem(
                  context,
                  nama: 'Depina',
                  kelas: 'XI TPM 1',
                  alat: 'Mesin Bor',
                  status: 'Dipinjam',
                ),
                const SizedBox(height: 12),
                _peminjamanItem(
                  context,
                  nama: 'Andi',
                  kelas: 'XI RPL 2',
                  alat: 'Obeng',
                  status: 'Kembali',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _peminjamanItem(
    BuildContext context, {
    required String nama,
    required String kelas,
    required String alat,
    required String status,
  }) {
    Color statusColor =
        status.toLowerCase() == 'dipinjam' ? Colors.orange : Colors.green;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DetailPeminjamanPage(),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(kelas),
                    Text('Alat: $alat'),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
