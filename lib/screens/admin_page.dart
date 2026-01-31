import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFFFF8E1); // cream
  static const Color primary = Color(0xFF2A5191);    // biru
  static const Color onPrimary = Colors.white;       // teks & icon di atas biru
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // cream
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: AppColors.primary, // biru
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            DashboardCard(title: 'User', icon: Icons.people),
            DashboardCard(title: 'Kategori', icon: Icons.category),
            DashboardCard(title: 'Alat', icon: Icons.build),
            DashboardCard(title: 'Peminjaman', icon: Icons.assignment),
          ],
        ),
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
      color: AppColors.primary, // biru
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.onPrimary),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.onPrimary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
