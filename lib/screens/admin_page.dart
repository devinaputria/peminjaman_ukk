import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard'), backgroundColor: Colors.blue, toolbarHeight: 200,),
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
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: AppColors.icon),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.icon,
              )),
        ],
      ),
    );
  }
}
