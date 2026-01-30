import 'package:flutter/material.dart';
import '../widgets/peminjam_bottom_nav.dart'; // pastikan file navbar sudah ada

class PeminjamDashboard extends StatefulWidget {
  const PeminjamDashboard({super.key});

  @override
  State<PeminjamDashboard> createState() => _PeminjamDashboardState();
}

class _PeminjamDashboardState extends State<PeminjamDashboard> {
  int _currentIndex = 0;

  // Halaman sederhana untuk tiap tab
  final List<Widget> _screens = [
    Center(child: Text('Beranda Peminjam', style: TextStyle(fontSize: 24))),
    Center(child: Text('Halaman Alat', style: TextStyle(fontSize: 24))),
    Center(child: Text('Halaman Peminjaman', style: TextStyle(fontSize: 24))),
    Center(child: Text('Riwayat Peminjaman', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profil Peminjam', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Peminjam'),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: PeminjamBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
