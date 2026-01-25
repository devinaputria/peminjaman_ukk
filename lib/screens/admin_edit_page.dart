import 'package:flutter/material.dart';
import 'package:peminjaman/screens/admin_dashboard.dart';
import 'package:peminjaman/screens/riwayat_page.dart';
import 'package:peminjaman/screens/transaksi.dart';

class EditMenuScreen extends StatelessWidget {
  const EditMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      {'icon': Icons.people, 'label': 'User'},
      {'icon': Icons.hardware, 'label': 'Alat'},
      {'icon': Icons.category, 'label': 'Kategori'},
    ];

      final List<Widget> _pages = [
        const AdminDashboard(),              // halaman Beranda (sudah ada)
        const EditMenuScreen(),          
        const TransaksiPage(),           
        const RiwayatPage(),              
      ];

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Master'), centerTitle: true, backgroundColor: Colors.blue, toolbarHeight: 200,),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: menus.length,
        itemBuilder: (_, i) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(menus[i]['icon'] as IconData, size: 28, color: Theme.of(context).primaryColor),
              title: Text(menus[i]['label'] as String, style: const TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.chevron_right, size: 28),
              onTap: () {
                // nanti arahkan ke halaman CRUD masing-masing
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Buka halaman ${menus[i]['label']}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}