import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class PeminjamBerandaPage extends StatelessWidget {
  const PeminjamBerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          // Salam
          const Text(
            'Halo, Peminjam 👋',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xff01386C), // ganti warna sesuai keinginan
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Mau pinjam alat apa hari ini?',
            style: TextStyle(
              color: Color(0xff01386C), // warna untuk subjudul
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),

          // Banner
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Sistem Peminjaman Alat',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Grid menu
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                menuItem(context, Icons.build, 'Alat', AppRoutes.alat),
                menuItem(context, Icons.shopping_cart, 'Peminjaman', AppRoutes.peminjaman),
                menuItem(context, Icons.history, 'Riwayat', AppRoutes.riwayat),
                menuItem(context, Icons.person, 'Profil', AppRoutes.profilDetail),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItem(BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade100,
              child: Icon(icon, color: Colors.blue, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label, 
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
