import 'package:flutter/material.dart';
import 'admin_pengembalian.dart';

class TransaksiPage extends StatelessWidget {
  const TransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= APPBAR =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: const Color(0xFF2A5191),
          elevation: 4,
          centerTitle: true,
          title: const Text(
            'Manajemen Transaksi',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      backgroundColor: const Color(0xFFF8F7F2),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===== HEADER INFO =====
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.swap_horiz,
                      color: Color(0xFF2A5191)),
                  SizedBox(width: 10),
                  Text(
                    'Pilih jenis transaksi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== PEMINJAMAN =====
            transaksiItem(
              context,
              icon: Icons.assignment,
              title: 'Peminjaman',
              subtitle: 'Proses pinjam alat oleh user',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminPengembalianPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            // ===== PENGEMBALIAN =====
            transaksiItem(
              context,
              icon: Icons.assignment_return,
              title: 'Pengembalian',
              subtitle: 'Konfirmasi alat kembali',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminPengembalianPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= ITEM CARD =================
  Widget transaksiItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        elevation: 3,
        shadowColor: Colors.black12,

        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),

          child: Row(
            children: [

              // ===== ICON BOX =====
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A5191).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF2A5191),
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              // ===== TEXT =====
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
