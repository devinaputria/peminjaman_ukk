import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class PeminjamBerandaPage extends StatelessWidget {
  const PeminjamBerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 247, 242),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ================= SALAM =================
              const Text(
                'Halo, Peminjam 👋',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff01386C),
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Mau pinjam alat apa hari ini?',
                style: TextStyle(
                  color: Color(0xff01386C),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              // ================= BANNER =================
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2A5191),
                      Color(0xFF1B3A70),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Sistem Peminjaman Alat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ================= GRID MENU =================
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.15,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  children: [
                    menuItem(
                        context, Icons.build, 'Alat', AppRoutes.alat),
                    menuItem(
                        context, Icons.shopping_cart, 'Peminjaman', AppRoutes.peminjaman),
                    menuItem(
                        context, Icons.history, 'Riwayat', AppRoutes.riwayat),
                    menuItem(
                        context, Icons.person, 'Profil', AppRoutes.profilDetail),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= WIDGET MENU =================
  Widget menuItem(
      BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF2A5191).withOpacity(0.1),
              child: Icon(
                icon,
                color: const Color(0xFF2A5191),
                size: 26,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
