import 'package:flutter/material.dart';
import 'package:peminjaman/screens/admin_edit_page.dart';
import 'package:peminjaman/screens/admin_page.dart';
import 'package:peminjaman/screens/riwayat_page.dart';
import 'package:peminjaman/screens/transaksi.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  // Daftar halaman (Widget) untuk BottomNavigationBar
  final List<Widget> _screens = [
    const AdminPage(),
    const EditMenuScreen(),
    const TransaksiPage(),
    const RiwayatPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index); // hanya ubah index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex, // tampilkan halaman aktif
        children: _screens, // semua halaman tetap ada
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }
}

// ========== HALAMAN-HALAMAN BARU ==========


// Daftar halaman (Widget) untuk BottomAppBar 
final List<Widget> _screens = [ const AdminPage(), const EditMenuScreen(), const TransaksiPage(), const RiwayatPage()
];

