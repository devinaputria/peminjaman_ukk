import 'package:flutter/material.dart';
import 'admin_edit_page.dart';
import 'admin_page.dart';
import 'riwayat_page.dart';
import 'transaksi.dart';
import 'package:peminjaman/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  // Child screens tanpa AppBar
  final List<Widget> _screens = [
    const AdminPage(),        // jangan ada AppBar di AdminPage
    const EditMenuScreen(),   // jangan ada AppBar di EditMenuScreen
    const TransaksiPage(),    // jangan ada AppBar di TransaksiPage
    const RiwayatPage(),      // jangan ada AppBar di RiwayatPage
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ AppBar tunggal
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: const Color(0xFF2A5191), // biru konsisten
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),

      // ✅ Background cream untuk seluruh dashboard
      backgroundColor: const Color(0xFFFFF8E7),

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2A5191), // biru
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}
