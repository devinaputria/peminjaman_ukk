import 'package:flutter/material.dart';
import 'admin_pengembalian.dart';

class TransaksiPage extends StatelessWidget {
  const TransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // ================= APPBAR MODERN =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // tinggi AppBar
        child: AppBar(
          backgroundColor: const Color(0xFF2A5191),
          elevation: 4,
          centerTitle: true,
          title: const Text(
            'Manajemen User',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      backgroundColor: const Color.fromARGB(255, 248, 247, 242), // cream background
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih jenis transaksi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),

            // PEMINJAMAN
            transaksiItem(
              context,
              icon: Icons.assignment,
              title: 'Peminjaman',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminPengembalianPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // PENGEMBALIAN
            transaksiItem(
              context,
              icon: Icons.assignment_return,
              title: 'Pengembalian',
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

  Widget transaksiItem(
    BuildContext context, {
    required IconData icon,
    required String title,
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
        shadowColor: Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue.shade100,
                child: Icon(icon, color: Colors.blue.shade700, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}