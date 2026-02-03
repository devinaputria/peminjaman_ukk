import 'package:flutter/material.dart';
import 'detail_peminjaman_page.dart';

class AdminPengembalianPage extends StatelessWidget {
  const AdminPengembalianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== BG SESUAI PERMINTAAN =====
      backgroundColor: const Color.fromARGB(255, 248, 247, 242),

      body: Column(
        children: [
          // ===== HEADER CUSTOM =====
          Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            decoration: const BoxDecoration(
              color: Color(0xFF2A5191),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
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
      borderRadius: BorderRadius.circular(18),

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
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 3,
        shadowColor: Colors.black26,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              // ===== AVATAR LEBIH CAKEP =====
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF2A5191).withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF2A5191),
                ),
              ),

              const SizedBox(width: 16),

              // ===== INFO =====
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

                    const SizedBox(height: 4),

                    Text(
                      kelas,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Alat: $alat',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== STATUS =====
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
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
                    const Icon(Icons.chevron_right, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
