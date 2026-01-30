import 'package:flutter/material.dart';
import 'peminjam_riwayat_page.dart';
import 'peminjam_beranda_page.dart';
import 'peminjam_alat_page.dart';
import 'peminjam_peminjaman_page.dart';
import 'peminjam_profil_page.dart';

class PeminjamDashboard extends StatefulWidget {
  const PeminjamDashboard({super.key});

  @override
  State<PeminjamDashboard> createState() => _PeminjamDashboardState();
}

class _PeminjamDashboardState extends State<PeminjamDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PeminjamBerandaPage(),
    const AlatPage(),            // pakai UI lama peminjam
    const PeminjamDashboard(),      // halaman peminjaman lama
    const PeminjamRiwayatPage(), // riwayat lama
    const PeminjamProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Peminjam'),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Alat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Peminjaman'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
