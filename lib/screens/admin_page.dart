import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color.fromARGB(255, 248, 247, 242); // cream
  static const Color primary = Color(0xFF2A5191);    // biru
  static const Color onPrimary = Colors.white;       // teks & icon di atas biru
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ===== HEADER BIRU CUSTOM =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Dashboard Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Kelola data utama ',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // ===== GRID DASHBOARD =====
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  DashboardCard(title: 'User', icon: Icons.people),
                  DashboardCard(title: 'Kategori', icon: Icons.category),
                  DashboardCard(title: 'Alat', icon: Icons.build),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const DashboardCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: navigasi ke halaman masing-masing
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}