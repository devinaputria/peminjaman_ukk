import 'package:flutter/material.dart';
import 'package:peminjaman/routes/app_routes.dart';

class PeminjamBerandaPage extends StatelessWidget {
  const PeminjamBerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // SAPAAN
            const Text(
              'Halo, Peminjam 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Mau pinjam alat apa hari ini?',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // BANNER
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(20),
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

            const SizedBox(height: 30),

            // MENU
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: [
                menuItem(
                  context,
                  icon: Icons.build,
                  label: 'Alat',
                  route: AppRoutes.alat,
                ),
                menuItem(
                  context,
                  icon: Icons.shopping_cart,
                  label: 'Peminjaman',
                  route: '/peminjaman',
                ),
                menuItem(
                  context,
                  icon: Icons.history,
                  label: 'Riwayat',
                  route: '/riwayat',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget menuItem(BuildContext context,
      {required IconData icon,
      required String label,
      required String route}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue.shade700),
          ),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}
